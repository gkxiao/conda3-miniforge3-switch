## 1. 前言
需要anaconda3与miniforge3这两个虚拟环境互相不干扰的独立存在，而又能切换。

## 2. 为每个 conda 创建独立的配置

参见config.sh

## 3. 为每个 conda 创建独立的配置

参见activate_anaconda.sh与activate_miniforge.sh

## 4. 创建快捷命令文件

参见conda_switch

## 5. 设置脚本权限和别名
<pre lang=bash>
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
</pre>

## 6. 使用方法
<pre lang=bash>
# 切换到 Anaconda3
. conda_switch anaconda
# 或
conda-ana

# 切换到 Miniforge3
. conda_switch miniforge
# 或
conda-mf

# 退出所有 conda
. conda_switch off
# 或
conda-off

# 查看当前状态
. conda_switch status
# 或
conda-switch status
</pre>

## 重要提示
<ol>
   <li>必须使用 source或 .命令，因为脚本需要修改当前 shell 的环境变量</li>
   <li>脚本会自动清理之前的 conda 配置，避免冲突</li>
   <li>每个 conda 使用独立的配置文件，完全隔离</li>
   <li>包含 mamba 的初始化，解决您遇到的问题</li>
</ol>

这样设置后，就可以在两个 conda 环境之间自由切换，互不干扰了。

## 验证
测试openfe_env的miniforge3环境
<pre lang=shell>
# 首先激活 Miniforge3
conda-mf

# 然后激活 openfe_env 环境
conda activate openfe_env
# 或者如果使用 mamba
mamba activate openfe_env

# 验证
conda info
which python
which mamba
</pre>
