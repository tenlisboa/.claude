#!/bin/bash

set -e 

echo "🚀 Instalando configurações do .claude..."

REPO="git@github.com:tenlisboa/.claude.git"
TEMP_DIR="/tmp/.claude"
DEST_DIR="$HOME/.claude"

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone "$REPO" "$TEMP_DIR"

mkdir -p "$DEST_DIR"

rsync -av "$TEMP_DIR/" "$DEST_DIR/"

rm -rf "$TEMP_DIR"

echo "Successfully installed .claude configurations to $DEST_DIR"
