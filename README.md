## 1. 前言
在我系统里，anaconda3与miniforge3同时存在，需要这两个虚拟环境互相不干扰的独立存在，而又能切换。

## 2. 为每个 conda 创建独立的配置
···
# 创建独立的 conda 配置文件
mkdir -p ~/.conda/miniforge
mkdir -p ~/.conda/anaconda

# 为 Miniforge3 创建独立配置
cat > ~/.conda/miniforge/.condarc << 'EOF'
envs_dirs:
  - /public/gkxiao/software/miniforge3/envs
  - ~/.conda/miniforge/envs
pkgs_dirs:
  - /public/gkxiao/software/miniforge3/pkgs
  - ~/.conda/miniforge/pkgs
auto_activate_base: false
channels:
  - conda-forge
  - defaults
EOF

# 为 Anaconda 创建独立配置
cat > ~/.conda/anaconda/.condarc << 'EOF'
envs_dirs:
  - /public/gkxiao/software/anaconda3/envs
  - ~/.conda/anaconda/envs
pkgs_dirs:
  - /public/gkxiao/software/anaconda3/pkgs
  - ~/.conda/anaconda/pkgs
auto_activate_base: false
channels:
  - defaults
EOF
···

## 2. 为每个 conda 创建独立的配置
参见activate_anaconda.sh与activate_miniforge.sh
