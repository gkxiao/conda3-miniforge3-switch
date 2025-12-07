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
