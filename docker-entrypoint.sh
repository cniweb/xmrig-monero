#!/bin/sh
set -eu

MSR_ENABLED="${XMRIG_MSR:-0}"
HUGE_PAGES_JIT_ENABLED="${XMRIG_HUGE_PAGES_JIT:-0}"
RANDOMX_1GB_PAGES_ENABLED="${XMRIG_RANDOMX_1GB_PAGES:-0}"

is_enabled() {
    case "$1" in
        1|true|TRUE|yes|YES|on|ON)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

if is_enabled "$MSR_ENABLED"; then
    if [ "$(id -u)" -ne 0 ]; then
        echo "MSR requested but the container is not running as root." >&2
        echo "Start the container with --user root and grant access to the host MSR device, for example:" >&2
        echo "  docker run --user root --cap-add=SYS_RAWIO --device=/dev/cpu:/dev/cpu -e XMRIG_MSR=1 <image>" >&2
        exit 1
    fi

    if [ -e /sys/module/msr/parameters/allow_writes ]; then
        echo on > /sys/module/msr/parameters/allow_writes
    elif command -v modprobe >/dev/null 2>&1; then
        modprobe msr allow_writes=on || true
    fi

    if [ ! -e /dev/cpu/0/msr ]; then
        echo "MSR requested but /dev/cpu/0/msr is not available inside the container." >&2
        echo "Load the msr kernel module on the host and pass /dev/cpu into the container, or use a privileged container on a Linux host." >&2
        exit 1
    fi

    echo "MSR support requested. Starting XMRig with elevated privileges so it can apply the RandomX MSR preset."
fi

if is_enabled "$RANDOMX_1GB_PAGES_ENABLED"; then
    if [ "$(id -u)" -ne 0 ]; then
        echo "RandomX 1GB huge pages requested but the container is not running as root." >&2
        echo "Start the container with --user root and configure 1GB huge pages on the Linux host first." >&2
        exit 1
    fi

    if [ -r /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages ]; then
        HUGE_PAGES_1GB_TOTAL="$(cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages)"

        if [ "$HUGE_PAGES_1GB_TOTAL" = "0" ]; then
            echo "RandomX 1GB huge pages requested, but the host currently has no 1GB huge pages reserved." >&2
            echo "Reserve them on the Linux host before starting the container, for example with XMRig's enable_1gb_pages.sh logic." >&2
        fi
    fi

    set -- --randomx-1gb-pages "$@"
fi

if is_enabled "$HUGE_PAGES_JIT_ENABLED"; then
    set -- --huge-pages-jit "$@"
fi

exec ./xmrig "$@"