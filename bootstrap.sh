#!/usr/bin/env bash

set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$BASEDIR"/bootstrap/file_system.sh
"$BASEDIR"/bootstrap/configs.sh "$BASEDIR"
"$BASEDIR"/bootstrap/dependencies.sh
