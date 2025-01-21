#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export LD_LIBRARY_PATH="$SCRIPT_DIR/lib_bundle:$LD_LIBRARY_PATH"
"$SCRIPT_DIR/bin_bundle/$1" "${@:2}"
