#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR="https://github.com/opentofu/opentofu/releases/download"

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-zip}
    local platform="${os}_${arch}"
    local file="tofu_${ver}_${platform}.${archive_type}"
    # https://github.com/opentofu/opentofu/releases/download/v1.6.0/tofu_1.6.0_linux_amd64.zip
    local url=$MIRROR/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep -e "$file\$" $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="tofu_${ver}_SHA256SUMS"

    # https://github.com/opentofu/opentofu/releases/download/v1.6.0/tofu_1.6.0_SHA256SUMS
    local url=$MIRROR/v$ver/$checksums

    local lchecksums=$DIR/$checksums
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums darwin arm64
    dl $ver $lchecksums freebsd arm
    dl $ver $lchecksums freebsd 386
    dl $ver $lchecksums freebsd amd64
    dl $ver $lchecksums linux 386
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux arm
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums openbsd 386
    dl $ver $lchecksums openbsd amd64
    dl $ver $lchecksums solaris amd64
    dl $ver $lchecksums windows 386
    dl $ver $lchecksums windows amd64
}

dl_ver ${1:-1.11.4}
