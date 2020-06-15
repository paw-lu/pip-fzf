#!/bin/bash
# pip-fzf
# Functions to offer fuzzy searching while using pip
# Must have pip, fzf, and curl installed
# Usage:
#   `pip install ** [TAB]`
#   `pip uninstall ** [TAB]`

_fzf_complete_pip() {
    # Offer fuzzy completion to `pip isntall` and `pip uninstall`
    # List all packages on PyPI with `pip install`
    # List all installed packages with `pip uninstall`
    local args
    args="$@"
    if [[ ${args} == 'pip uninstall'* ]]; then
        local installed_packages
        installed_packages=$(python -m pip list | tail -n +3)
        _fzf_complete --reverse --multi -- "${args}" < <(
            echo "$installed_packages"
        )
    elif [[ ${args} == 'pip install'* ]]; then
        local all_packages
        all_packages=$(curl -s https://pypi.org/simple/ | tail -n +7 | sed 's/<[^>]*>//g')
        _fzf_complete --reverse --multi -- "${args}" < <(
            echo "$all_packages"
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_pip_post() {
    # Process the output when selecting from the results provided by
    # `_fzf_complete_pip`
    # Returns only tha package name, ignoring the version number
    awk '{print $1}'
}
