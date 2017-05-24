#!/bin/sh

name="$(grep -oP '(?<=name = ")[^"]*(?=")' Cargo.toml)"
path="target/release"

if ! grep -q "lto = true" Cargo.toml; then
	echo "---"
	echo "Maybe you want to add:\n"
	echo "[profile.release]"
	echo "lto = true"
	echo "\nto your Cargo.toml file in order to get a smaller binary."
	echo "---\n"
fi

cargo build --release
strip -v "$path/$name"
upx "$path/$name"
echo "---"
file "$path/$name"
ldd "$path/$name"