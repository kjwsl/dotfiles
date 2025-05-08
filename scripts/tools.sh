#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1 ✅"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1 ❌"
}

safe_cd() {
    TARGET="$1"
    cd $TARGET || {
        error "Failed to change directory into $TARGET"
        exit 1
    }
}
