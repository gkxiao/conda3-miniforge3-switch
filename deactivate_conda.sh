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
