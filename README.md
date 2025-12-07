1. 创建独立的配置目录

首先，为每个 conda 创建独立的配置：
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


2. 创建激活脚本

文件名：~/bin/activate_anaconda.sh
#!/bin/bash
# 注意：此脚本必须用 source 命令运行
# 使用方法: source activate_anaconda.sh

if [[ "$(basename -- "$0")" == "activate_anaconda.sh" ]]; then
    echo "错误: 此脚本必须用 'source' 命令运行"
    echo "正确用法: source $(basename -- "$0")"
    return 1
fi

# 清理现有的 conda 配置
cleanup_conda() {
    # 退出所有 conda 环境
    while [[ -n "$CONDA_SHLVL" ]] && [[ "$CONDA_SHLVL" -gt 0 ]]; do
        conda deactivate 2>/dev/null
    done
    
    # 清理 conda 相关函数
    unset -f conda 2>/dev/null
    unset -f __conda_activate 2>/dev/null
    unset -f __conda_reactivate 2>/dev/null
    unset -f __conda_hashr 2>/dev/null
    
    # 清理 conda 相关变量
    unset CONDA_EXE
    unset CONDA_PREFIX
    unset CONDA_PYTHON_EXE
    unset CONDA_DEFAULT_ENV
    unset CONDA_PROMPT_MODIFIER
    unset CONDA_SHLVL
    unset CONDA_PREFIX_1
    
    # 从 PATH 中移除 conda 相关路径
    export PATH=$(echo $PATH | tr ':' '\n' | grep -vE "(anaconda3|miniforge3|conda)" | tr '\n' ':' | sed 's/:$//')
    
    # 清理 mamba 相关变量
    unset MAMBA_EXE
    unset MAMBA_ROOT_PREFIX
}

echo "正在清理现有 conda 环境..."
cleanup_conda

# 设置 Anaconda 路径
ANACONDA_PATH="/public/gkxiao/software/anaconda3"

if [[ ! -f "$ANACONDA_PATH/bin/conda" ]]; then
    echo "错误: 在 $ANACONDA_PATH 未找到 Anaconda"
    return 1
fi

# 设置 Anaconda 专用的配置
export CONDA_ROOT_PREFIX="$ANACONDA_PATH"
export CONDA_PKGS_DIRS="$ANACONDA_PATH/pkgs:~/.conda/anaconda/pkgs"
export CONDA_ENVS_DIRS="$ANACONDA_PATH/envs:~/.conda/anaconda/envs"
export CONDARC="$HOME/.conda/anaconda/.condarc"

echo "正在初始化 Anaconda3..."

# 使用 eval 初始化 conda
if [[ -f "$ANACONDA_PATH/etc/profile.d/conda.sh" ]]; then
    . "$ANACONDA_PATH/etc/profile.d/conda.sh"
else
    # 如果 conda.sh 不存在，使用传统方法
    export PATH="$ANACONDA_PATH/bin:$PATH"
    
    # 手动设置 conda shell 函数
    __conda_setup="$('$ANACONDA_PATH/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    else
        echo "警告: 无法设置 conda shell hook"
    fi
    unset __conda_setup
fi

echo "="======================================="
echo "  Anaconda3 已激活"
echo "  版本: $(conda --version 2>/dev/null || echo '未知')"
echo "  路径: $ANACONDA_PATH"
echo "  配置文件: $CONDARC"
echo "="======================================="


文件名：~/bin/activate_miniforge.sh
#!/bin/bash
# 注意：此脚本必须用 source 命令运行
# 使用方法: source activate_miniforge.sh

if [[ "$(basename -- "$0")" == "activate_miniforge.sh" ]]; then
    echo "错误: 此脚本必须用 'source' 命令运行"
    echo "正确用法: source $(basename -- "$0")"
    return 1
fi

# 清理现有的 conda 配置
cleanup_conda() {
    # 退出所有 conda 环境
    while [[ -n "$CONDA_SHLVL" ]] && [[ "$CONDA_SHLVL" -gt 0 ]]; do
        conda deactivate 2>/dev/null
    done
    
    # 清理 conda 相关函数
    unset -f conda 2>/dev/null
    unset -f __conda_activate 2>/dev/null
    unset -f __conda_reactivate 2>/dev/null
    unset -f __conda_hashr 2>/dev/null
    
    # 清理 conda 相关变量
    unset CONDA_EXE
    unset CONDA_PREFIX
    unset CONDA_PYTHON_EXE
    unset CONDA_DEFAULT_ENV
    unset CONDA_PROMPT_MODIFIER
    unset CONDA_SHLVL
    unset CONDA_PREFIX_1
    
    # 从 PATH 中移除 conda 相关路径
    export PATH=$(echo $PATH | tr ':' '\n' | grep -vE "(anaconda3|miniforge3|conda)" | tr '\n' ':' | sed 's/:$//')
    
    # 清理 mamba 相关变量
    unset MAMBA_EXE
    unset MAMBA_ROOT_PREFIX
}

echo "正在清理现有 conda 环境..."
cleanup_conda

# 设置 Miniforge3 路径
MINIFORGE_PATH="/public/gkxiao/software/miniforge3"

if [[ ! -f "$MINIFORGE_PATH/bin/conda" ]]; then
    echo "错误: 在 $MINIFORGE_PATH 未找到 Miniforge3"
    return 1
fi

# 设置 Miniforge3 专用的配置
export CONDA_ROOT_PREFIX="$MINIFORGE_PATH"
export CONDA_PKGS_DIRS="$MINIFORGE_PATH/pkgs:~/.conda/miniforge/pkgs"
export CONDA_ENVS_DIRS="$MINIFORGE_PATH/envs:~/.conda/miniforge/envs"
export CONDARC="$HOME/.conda/miniforge/.condarc"

echo "正在初始化 Miniforge3..."

# 首先添加 conda 到 PATH
export PATH="$MINIFORGE_PATH/bin:$PATH"

# 初始化 conda
if [[ -f "$MINIFORGE_PATH/etc/profile.d/conda.sh" ]]; then
    . "$MINIFORGE_PATH/etc/profile.d/conda.sh"
else
    # 手动设置 conda shell 函数
    __conda_setup="$('$MINIFORGE_PATH/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    else
        echo "警告: 无法设置 conda shell hook"
    fi
    unset __conda_setup
fi

# 初始化 mamba（如果存在）
if [[ -f "$MINIFORGE_PATH/bin/mamba" ]]; then
    echo "正在初始化 mamba..."
    eval "$($MINIFORGE_PATH/bin/mamba shell hook --shell bash)"
    if [[ $? -eq 0 ]]; then
        echo "Mamba 初始化成功"
    else
        echo "警告: 无法初始化 mamba"
    fi
fi

echo "="======================================="
echo "  Miniforge3 已激活"
echo "  conda 版本: $(conda --version 2>/dev/null || echo '未知')"
if command -v mamba &> /dev/null; then
    echo "  mamba 版本: $(mamba --version 2>/dev/null | head -1 || echo '未知')"
fi
echo "  路径: $MINIFORGE_PATH"
echo "  配置文件: $CONDARC"
echo "="======================================="


文件名：~/bin/deactivate_conda.sh
#!/bin/bash
# 退出所有 conda 环境的脚本
# 使用方法: source deactivate_conda.sh

if [[ "$(basename -- "$0")" == "deactivate_conda.sh" ]]; then
    echo "错误: 此脚本必须用 'source' 命令运行"
    echo "正确用法: source $(basename -- "$0")"
    return 1
fi

# 退出所有 conda 环境
while [[ -n "$CONDA_SHLVL" ]] && [[ "$CONDA_SHLVL" -gt 0 ]]; do
    echo "正在退出 conda 环境 (层级: $CONDA_SHLVL)"
    conda deactivate
done

# 清理 conda 相关函数
unset -f conda 2>/dev/null
unset -f __conda_activate 2>/dev/null
unset -f __conda_reactivate 2>/dev/null
unset -f __conda_hashr 2>/dev/null
unset -f mamba 2>/dev/null
unset -f micromamba 2>/dev/null

# 清理 conda 相关变量
unset CONDA_EXE
unset CONDA_PREFIX
unset CONDA_PYTHON_EXE
unset CONDA_DEFAULT_ENV
unset CONDA_PROMPT_MODIFIER
unset CONDA_SHLVL
unset CONDA_PREFIX_1
unset CONDA_ROOT_PREFIX
unset CONDARC
unset CONDA_PKGS_DIRS
unset CONDA_ENVS_DIRS

# 清理 mamba 相关变量
unset MAMBA_EXE
unset MAMBA_ROOT_PREFIX

# 从 PATH 中移除 conda 相关路径
export PATH=$(echo $PATH | tr ':' '\n' | grep -vE "(anaconda3|miniforge3|conda|mamba)" | tr '\n' ':' | sed 's/:$//')

echo "="======================================="
echo "  所有 conda 环境已退出"
echo "  系统已恢复到原始状态"
echo "="======================================="


3. 创建快捷命令文件

文件名：~/bin/conda_switch
#!/bin/bash
# 快速切换 conda 环境的脚本
# 使用方法: . conda_switch [anaconda|miniforge|off]

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$1" in
    anaconda|ana)
        echo "切换到 Anaconda3..."
        source "$SCRIPT_DIR/activate_anaconda.sh"
        ;;
    miniforge|mf|mamba)
        echo "切换到 Miniforge3..."
        source "$SCRIPT_DIR/activate_miniforge.sh"
        ;;
    off|none)
        echo "退出所有 conda 环境..."
        source "$SCRIPT_DIR/deactivate_conda.sh"
        ;;
    status|check)
        echo "当前 conda 状态:"
        echo "----------------"
        if command -v conda &> /dev/null; then
            echo "✓ conda 已激活"
            echo "  路径: $(which conda)"
            echo "  版本: $(conda --version 2>/dev/null || echo '未知')"
            
            if [[ -n "$CONDA_SHLVL" ]]; then
                echo "  激活级别: $CONDA_SHLVL"
            fi
            
            if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
                echo "  当前环境: $CONDA_DEFAULT_ENV"
            fi
            
            if command -v mamba &> /dev/null; then
                echo "  ✓ mamba 可用"
                echo "    版本: $(mamba --version 2>/dev/null | head -1)"
            fi
            
            # 检查是哪个 conda
            if which conda | grep -q "anaconda3"; then
                echo "  类型: Anaconda3"
            elif which conda | grep -q "miniforge3"; then
                echo "  类型: Miniforge3"
            fi
        else
            echo "✗ conda 未激活"
        fi
        ;;
    *)
        echo "用法: . conda_switch {anaconda|miniforge|off|status}"
        echo ""
        echo "命令说明:"
        echo "  anaconda, ana    切换到 Anaconda3"
        echo "  miniforge, mf    切换到 Miniforge3"
        echo "  off, none        退出所有 conda 环境"
        echo "  status, check    查看当前状态"
        echo ""
        echo "注意: 必须使用 '.' 或 'source' 运行此命令"
        echo "例如: . conda_switch anaconda"
        return 1
        ;;
esac


4. 设置脚本权限和别名

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


5. 使用方法

现在您可以使用以下命令：
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


6. 验证您的 openfe_env 环境

现在您可以正确激活您的 openfe_env 环境：
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


重要提示

1. 必须使用 source 或 . 命令，因为脚本需要修改当前 shell 的环境变量
2. 脚本会自动清理之前的 conda 配置，避免冲突
3. 每个 conda 使用独立的配置文件，完全隔离
4. 包含 mamba 的初始化，解决您遇到的问题

这样设置后，您就可以在两个 conda 环境之间自由切换，互不干扰了。
