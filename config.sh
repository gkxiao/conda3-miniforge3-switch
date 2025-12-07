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
