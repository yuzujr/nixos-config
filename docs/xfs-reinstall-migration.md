# Btrfs -> XFS Reinstall Migration

本文档针对当前这台机器的一次性迁移，前提如下：

- 目标系统盘：`/dev/nvme0n1`
- 当前布局：
  - `/dev/nvme0n1p1` 为 EFI 分区，挂载到 `/efi`
  - `/dev/nvme0n1p4` 为单分区 Btrfs 根文件系统
- 目标布局：
  - `/dev/nvme0n1p1` 为新的 EFI 分区
  - `/dev/nvme0n1p2` 为新的 XFS 根分区
- 不保留旧系统并存
- 你的个人文件、游戏和配置会先转移到另一块磁盘，再重装，再拷回
- 这份 flake 最终仍然放在 `/home/yuzujr/nixos-config`
- 私有 secrets 仓库最终仍然放在 `/home/yuzujr/nix-secrets`

当前仓库里的几个关键事实：

- `vars/default.nix` 把 `repoRoot` 固定成了 `/home/yuzujr/nixos-config`
- `home/xdg-config-links.nix` 和相关 Home Manager 模块大量使用 out-of-store symlink
- `flake.nix` 里的 `mysecrets` 默认指向占位目录，实际使用时需要 `--override-input mysecrets path:/home/yuzujr/nix-secrets`
- `secrets/nixos.nix` 用 `/etc/ssh/ssh_host_ed25519_key` 作为 `agenix` 解密身份
- 当前配置没有磁盘 swap，只启用了 `zramSwap`

这意味着：

- 重装前必须备份整个 `nixos-config` 工作树，而不是重新 clone
- 重装前必须备份 `nix-secrets`
- 重装前必须备份旧系统的 `/etc/ssh/ssh_host_ed25519_key`
- 新系统里必须恢复出同样的目录路径，否则 Home Manager 的符号链接会指向不存在的位置

## 1. 迁移前检查

在旧系统里确认磁盘：

```bash
lsblk -f
```

本机当前应接近如下结果：

```text
nvme0n1
├─nvme0n1p1 vfat   ...   /efi
└─nvme0n1p4 btrfs  ...   /

nvme1n1
├─...
```

确认你要拿来暂存数据的分区。下面示例统一用 `<backup-partition>` 表示，例如：

- `/dev/nvme1n1p4`
- `/dev/sda1`

如果暂存盘是 NTFS 或 exFAT，需要注意：

- 普通文件、视频、图片、游戏资源目录直接复制通常没问题
- 带 Unix 权限、软链接、隐藏配置的目录不要直接裸拷，建议打包成 tar 再存过去
- `nixos-config`、`nix-secrets`、`/etc/ssh/ssh_host_ed25519_key` 建议都用 tar 或 `install` 单独处理

## 2. 在旧系统里备份必须保留的内容

### 2.1 挂载暂存盘

如果暂存盘是 NTFS，可这样挂载：

```bash
sudo mkdir -p /mnt/backup
sudo mount -t ntfs3 <backup-partition> /mnt/backup
```

如果暂存盘本来就是 Linux 文件系统，直接正常挂载即可：

```bash
sudo mkdir -p /mnt/backup
sudo mount <backup-partition> /mnt/backup
```

创建一个本次迁移专用目录：

```bash
mkdir -p /mnt/backup/nixos-xfs-migration
```

### 2.2 备份 flake 仓库、secrets 和主机密钥

先备份最关键的三样：

```bash
tar -C /home/yuzujr -cpf /mnt/backup/nixos-xfs-migration/nixos-config.tar nixos-config
tar -C /home/yuzujr -cpf /mnt/backup/nixos-xfs-migration/nix-secrets.tar nix-secrets
sudo tar -C / -cpf /mnt/backup/nixos-xfs-migration/ssh-host-ed25519.tar \
  etc/ssh/ssh_host_ed25519_key \
  etc/ssh/ssh_host_ed25519_key.pub
```

说明：

- `nixos-config.tar` 会保留你当前未提交的本地改动
- `nix-secrets.tar` 会保留 `.age` 文件
- `ssh-host-ed25519.tar` 用于让新系统继续解密现有 `agenix` secrets

### 2.3 备份个人文件和游戏

普通数据目录可直接复制，例如：

```bash
rsync -aH --info=progress2 /home/yuzujr/Documents/ /mnt/backup/nixos-xfs-migration/home/Documents/
rsync -aH --info=progress2 /home/yuzujr/Downloads/ /mnt/backup/nixos-xfs-migration/home/Downloads/
rsync -aH --info=progress2 /home/yuzujr/Pictures/ /mnt/backup/nixos-xfs-migration/home/Pictures/
rsync -aH --info=progress2 /home/yuzujr/Videos/ /mnt/backup/nixos-xfs-migration/home/Videos/
rsync -aH --info=progress2 /home/yuzujr/Games/ /mnt/backup/nixos-xfs-migration/home/Games/
```

如果你要保留 Steam 相关内容，建议按体量决定：

- 只保留游戏资源库：直接复制 Steam library 目录
- 想尽量保留完整客户端状态、前缀和兼容层数据：建议打 tar

例如：

```bash
tar -C /home/yuzujr -cpf /mnt/backup/nixos-xfs-migration/steam-state.tar \
  .steam \
  .local/share/Steam
```

如果还有必须保留但不在 flake 里的程序数据，也同样备份，例如：

- `~/.ssh`
- `~/.local/share`
- `~/.config` 里某些运行时生成目录
- 安卓开发、IDE、模拟器、Wine/Proton 前缀

这类目录若在 NTFS 上暂存，优先使用 tar。

### 2.4 记录当前系统信息

把当前挂载和块设备信息也顺手存一下，后面核对方便：

```bash
lsblk -f > /mnt/backup/nixos-xfs-migration/lsblk-before.txt
findmnt / /efi > /mnt/backup/nixos-xfs-migration/findmnt-before.txt
```

### 2.5 卸载暂存盘并关机进入安装环境

```bash
sync
sudo umount /mnt/backup
sudo poweroff
```

然后从 NixOS 安装 ISO 启动。

## 3. 在安装 ISO 里重建 `nvme0n1`

### 3.1 再次确认设备名

进入 ISO 后先确认目标盘仍然是 `nvme0n1`：

```bash
lsblk -f
```

下面所有破坏性操作都只针对 `/dev/nvme0n1`。

### 3.2 抹掉旧分区表并重建 GPT

```bash
wipefs -a /dev/nvme0n1
parted -s /dev/nvme0n1 mklabel gpt
```

### 3.3 创建新的 EFI + XFS 分区

这里给 EFI 1 GiB，其余全部给 XFS 根分区：

```bash
parted -s /dev/nvme0n1 \
  mkpart ESP fat32 1MiB 1025MiB \
  set 1 esp on \
  mkpart primary xfs 1025MiB 100%
```

### 3.4 格式化

```bash
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1
mkfs.xfs -f -L nixos /dev/nvme0n1p2
```

### 3.5 挂载目标系统

你的配置使用 `/efi` 作为 EFI 挂载点，所以安装时也这样挂：

```bash
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
```

## 4. 在安装 ISO 里恢复 flake、secrets 和主机密钥

### 4.1 挂载暂存盘

假设还是 `<backup-partition>`：

```bash
mkdir -p /mnt/backup
mount -t ntfs3 <backup-partition> /mnt/backup
```

如果不是 NTFS，就按实际文件系统挂载。

### 4.2 恢复仓库和 secrets 到最终路径

先创建目录：

```bash
mkdir -p /mnt/home/yuzujr
```

恢复 flake：

```bash
tar -C /mnt/home/yuzujr -xpf /mnt/backup/nixos-xfs-migration/nixos-config.tar
```

恢复 secrets：

```bash
tar -C /mnt/home/yuzujr -xpf /mnt/backup/nixos-xfs-migration/nix-secrets.tar
```

恢复 `agenix` 需要的 SSH host key：

```bash
mkdir -p /mnt/etc/ssh
tar -C /mnt -xpf /mnt/backup/nixos-xfs-migration/ssh-host-ed25519.tar
chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
chmod 644 /mnt/etc/ssh/ssh_host_ed25519_key.pub
```

恢复后应存在：

- `/mnt/home/yuzujr/nixos-config`
- `/mnt/home/yuzujr/nix-secrets`
- `/mnt/etc/ssh/ssh_host_ed25519_key`

## 5. 生成新硬件配置并覆盖仓库中的旧 Btrfs 配置

你的仓库当前 `hosts/default/hardware-configuration.nix` 仍然写的是 Btrfs 根。重装到 XFS 后，必须用新生成的版本替换它。

先生成：

```bash
nixos-generate-config --root /mnt
```

然后覆盖仓库中的硬件配置：

```bash
cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/home/yuzujr/nixos-config/hosts/default/hardware-configuration.nix
```

建议再检查一遍生成结果：

```bash
sed -n '1,220p' /mnt/home/yuzujr/nixos-config/hosts/default/hardware-configuration.nix
```

你需要确认至少有这几点：

- `fileSystems."/"` 的 `fsType = "xfs"`
- 根分区设备指向新的 `/dev/disk/by-uuid/...`
- `fileSystems."/efi"` 仍然存在，且 `fsType = "vfat"`

## 6. 用 flake 安装系统

### 6.1 可选：先验证 flake 能否求值

```bash
nix --extra-experimental-features 'nix-command flakes' \
  flake show /mnt/home/yuzujr/nixos-config
```

### 6.2 正式安装

这份仓库的私有配置依赖 `mysecrets` override，因此安装时要显式带上：

```bash
nixos-install \
  --flake /mnt/home/yuzujr/nixos-config#nixos \
  --override-input mysecrets path:/mnt/home/yuzujr/nix-secrets
```

如果你只想先装公开配置、暂时绕过私有 secrets，再自己后补，可以改用：

```bash
nixos-install \
  --flake /mnt/home/yuzujr/nixos-config#nixos-public
```

但按照你当前使用方式，更推荐直接安装 `#nixos`，前提是上一步已经恢复了旧 SSH host key 和 `nix-secrets`。

## 7. 安装后、重启前的必要处理

### 7.1 设置用户密码

你的配置里没有声明式 `hashedPassword`。重装后，最好在重启前直接设置：

```bash
nixos-enter --root /mnt -c 'passwd yuzujr'
```

如有需要，也设置 root 密码：

```bash
nixos-enter --root /mnt -c 'passwd'
```

### 7.2 卸载并重启

```bash
sync
umount -R /mnt
reboot
```

## 8. 首次进入新系统后的检查

启动进入新系统后，先确认根文件系统已经是 XFS：

```bash
findmnt / -o SOURCE,TARGET,FSTYPE,OPTIONS
```

预期 `FSTYPE` 为 `xfs`。

再确认 EFI：

```bash
findmnt /efi -o SOURCE,TARGET,FSTYPE,OPTIONS
```

再确认 flake 路径已经正确恢复：

```bash
ls -la /home/yuzujr/nixos-config
ls -la /home/yuzujr/nix-secrets
```

然后做一次重建，确认系统能在新系统里自举：

```bash
sudo nixos-rebuild switch \
  --flake /home/yuzujr/nixos-config#nixos \
  --override-input mysecrets path:/home/yuzujr/nix-secrets
```

## 9. 恢复个人数据

### 9.1 挂载暂存盘

```bash
sudo mkdir -p /mnt/backup
sudo mount -t ntfs3 <backup-partition> /mnt/backup
```

### 9.2 恢复普通文件

例如：

```bash
rsync -aH --info=progress2 /mnt/backup/nixos-xfs-migration/home/Documents/ /home/yuzujr/Documents/
rsync -aH --info=progress2 /mnt/backup/nixos-xfs-migration/home/Downloads/ /home/yuzujr/Downloads/
rsync -aH --info=progress2 /mnt/backup/nixos-xfs-migration/home/Pictures/ /home/yuzujr/Pictures/
rsync -aH --info=progress2 /mnt/backup/nixos-xfs-migration/home/Videos/ /home/yuzujr/Videos/
rsync -aH --info=progress2 /mnt/backup/nixos-xfs-migration/home/Games/ /home/yuzujr/Games/
```

### 9.3 恢复 tar 打包的数据

例如 Steam 状态：

```bash
tar -C /home/yuzujr -xpf /mnt/backup/nixos-xfs-migration/steam-state.tar
```

如果恢复完后文件属主不对，修正一次：

```bash
sudo chown -R yuzujr:users /home/yuzujr
```

只在你确认属主确实错了时再运行，不要无脑执行到整个 home。

### 9.4 卸载暂存盘

```bash
sync
sudo umount /mnt/backup
```

## 10. 建议的迁移顺序

按这个顺序做最稳：

1. 在旧系统里把关键内容备份到另一块盘
2. 确认 `nixos-config.tar`、`nix-secrets.tar`、`ssh-host-ed25519.tar` 都已生成
3. 用 ISO 启动
4. 抹掉 `nvme0n1` 并重建为 `EFI + XFS`
5. 把 flake、secrets、host key 恢复到 `/mnt`
6. 生成新的 `hardware-configuration.nix`
7. 执行 `nixos-install --flake ... --override-input mysecrets ...`
8. 设置 `yuzujr` 密码
9. 重启进入新系统
10. 再从备份盘拷回大文件和游戏

## 11. 常见失败点

### 11.1 忘了备份旧 SSH host key

现象：

- `agenix` secrets 无法解密
- `#nixos` 安装或切换失败

原因：

- 你的 secrets 解密身份是 `/etc/ssh/ssh_host_ed25519_key`

解决：

- 重装前备份旧 key
- 重装时恢复到 `/mnt/etc/ssh/ssh_host_ed25519_key`

### 11.2 忘了恢复 `nix-secrets`

现象：

- `--override-input mysecrets path:/...` 指向的目录不存在
- 私有 profile 无法求值

解决：

- 确保 `/home/yuzujr/nix-secrets` 已恢复
- 安装和重建时都带上 `--override-input mysecrets path:/home/yuzujr/nix-secrets`

### 11.3 把 flake 放在了别的路径

现象：

- Home Manager 的 out-of-store symlink 指向错误位置
- 各类 dotfiles 没生效或链接断裂

解决：

- 仓库必须恢复到 `/home/yuzujr/nixos-config`

### 11.4 直接把需要权限和软链接的目录裸拷到 NTFS

现象：

- 恢复后权限异常
- 符号链接丢失
- 某些程序状态损坏

解决：

- 对这类目录使用 tar

## 12. 本机最小命令清单

如果你只想看最短版本，可以按下面执行。

旧系统：

```bash
sudo mount -t ntfs3 <backup-partition> /mnt/backup
mkdir -p /mnt/backup/nixos-xfs-migration
tar -C /home/yuzujr -cpf /mnt/backup/nixos-xfs-migration/nixos-config.tar nixos-config
tar -C /home/yuzujr -cpf /mnt/backup/nixos-xfs-migration/nix-secrets.tar nix-secrets
sudo tar -C / -cpf /mnt/backup/nixos-xfs-migration/ssh-host-ed25519.tar \
  etc/ssh/ssh_host_ed25519_key \
  etc/ssh/ssh_host_ed25519_key.pub
sync
sudo umount /mnt/backup
```

安装 ISO：

```bash
wipefs -a /dev/nvme0n1
parted -s /dev/nvme0n1 mklabel gpt
parted -s /dev/nvme0n1 \
  mkpart ESP fat32 1MiB 1025MiB \
  set 1 esp on \
  mkpart primary xfs 1025MiB 100%
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1
mkfs.xfs -f -L nixos /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
mount -t ntfs3 <backup-partition> /mnt/backup
mkdir -p /mnt/home/yuzujr /mnt/etc/ssh
tar -C /mnt/home/yuzujr -xpf /mnt/backup/nixos-xfs-migration/nixos-config.tar
tar -C /mnt/home/yuzujr -xpf /mnt/backup/nixos-xfs-migration/nix-secrets.tar
tar -C /mnt -xpf /mnt/backup/nixos-xfs-migration/ssh-host-ed25519.tar
chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
chmod 644 /mnt/etc/ssh/ssh_host_ed25519_key.pub
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/yuzujr/nixos-config/hosts/default/hardware-configuration.nix
nixos-install \
  --flake /mnt/home/yuzujr/nixos-config#nixos \
  --override-input mysecrets path:/mnt/home/yuzujr/nix-secrets
nixos-enter --root /mnt -c 'passwd yuzujr'
sync
umount -R /mnt
reboot
```
