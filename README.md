## 1. 前言
在我系统里，anaconda3与miniforge3同时存在，需要这两个虚拟环境互相不干扰的独立存在，而又能切换。

## 2. 为每个 conda 创建独立的配置

参见config.sh

## 3. 为每个 conda 创建独立的配置

参见activate_anaconda.sh与activate_miniforge.sh

## 4. 创建快捷命令文件

参见conda_switch

## 5. 设置脚本权限和别名
<code>
# 创建 bin 目录（如果不存在）
mkdir -p ~/bin

# 将上述脚本保存到 ~/bin/ 目录下
# 然后设置权限
chmod +x ~/bin/activate_anaconda.sh
chmod +x ~/bin/activate_miniforge.sh
chmod +x ~/bin/deactivate_conda.sh
chmod +x ~/bin/conda_switch

# 在 ~/.bashrc 中添加别名
echo '' >> ~/.bashrc
echo '# Conda 环境切换别名' >> ~/.bashrc
echo 'alias conda-ana="source ~/bin/activate_anaconda.sh"' >> ~/.bashrc
echo 'alias conda-mf="source ~/bin/activate_miniforge.sh"' >> ~/.bashrc
echo 'alias conda-off="source ~/bin/deactivate_conda.sh"' >> ~/.bashrc
echo 'alias conda-switch="source ~/bin/conda_switch"' >> ~/.bashrc

# 重新加载 bashrc
source ~/.bashrc
</code>
