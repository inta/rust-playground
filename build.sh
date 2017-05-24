#!/bin/sh

name="$(grep -oP '(?<=name = ")[^"]*(?=")' Cargo.toml)"
path="target/release"
params="--release"

while [ "$1" != '' ]; do
	prefix="$(echo "$1" | cut -d = -f 1)"
	target="$(echo "$1" | cut -d = -f 2)"
	if [ "$1" = "--static" ]; then
		prefix="--target"
		target="x86_64-unknown-linux-musl"
	fi
	if [ "$prefix" = "--target" ]; then
		path="target/$target/release"
		params="$params $prefix=$target"
		shift
	fi
done

if ! grep -q "lto = true" Cargo.toml; then
	echo "---"
	echo "Maybe you want to add:"
	echo
	echo "[profile.release]"
	echo "lto = true"
	echo
	echo "to your Cargo.toml file in order to get a smaller binary."
	echo "---"
fi

cargo build $params
strip -v "$path/$name"
upx "$path/$name"
echo "---"
file "$path/$name"
ldd "$path/$name"