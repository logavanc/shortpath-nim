#!/usr/bin/env bash
# Run from the script's directory.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

# Required packages:
# nim (choosenim)
# musl-gcc
# upx
# strip (binutils)

# Build the static binary and make it as small and optimized as possible:
# https://scripter.co/nim-deploying-static-binaries/
nimble build \
	--gcc.exe:musl-gcc \
	--gcc.linkerexe:musl-gcc \
	--passL:-static \
	--opt:size \
	-d:VERSION:1.0.0 \
	-d:release

# Strip the binary and compress it with UPX.
strip --strip-all ./shortpath || true
upx --best ./shortpath || true
ls -lah "$(readlink -f ./shortpath)"

# Check that the binary is statically linked.
file ./shortpath | grep 'static.* linked'
