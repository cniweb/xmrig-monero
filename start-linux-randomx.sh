#!/bin/sh
set -eu

log() {
    echo "$1"
}

warn() {
    echo "$1" >&2
}

if [ "$(id -u)" -ne 0 ]; then
    warn "The Linux RandomX startup profile requires root inside the container."
    exit 1
fi

CPU_COUNT="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"
EXTRA_ARGS=""

if [ -w /proc/sys/vm/nr_hugepages ]; then
    echo "$CPU_COUNT" > /proc/sys/vm/nr_hugepages || warn "Could not reserve 2MB huge pages on the host."
else
    warn "Cannot write to /proc/sys/vm/nr_hugepages. 2MB huge pages were not adjusted."
fi

ONE_GB_PAGES_SET=0
for node_path in /sys/devices/system/node/node*; do
    one_gb_pages_file="$node_path/hugepages/hugepages-1048576kB/nr_hugepages"

    if [ -w "$one_gb_pages_file" ]; then
        echo 3 > "$one_gb_pages_file" || warn "Could not reserve 1GB huge pages for $node_path."
        ONE_GB_PAGES_SET=1
    fi
done

if [ "$ONE_GB_PAGES_SET" -eq 0 ]; then
    warn "No writable 1GB huge pages sysfs entries found. RandomX 1GB pages may stay disabled."
fi

if [ -e /sys/module/msr/parameters/allow_writes ]; then
    echo on > /sys/module/msr/parameters/allow_writes || warn "Could not enable MSR writes through /sys/module/msr."
elif command -v modprobe >/dev/null 2>&1; then
    modprobe msr allow_writes=on || warn "Could not load the msr module from inside the container."
else
    warn "modprobe is unavailable in the runtime image. Load the msr module on the host if MSR setup fails."
fi

if [ ! -e /dev/cpu/0/msr ]; then
    warn "MSR device /dev/cpu/0/msr is not available. RandomX MSR optimization may fail."
fi

if [ "${XMRIG_NO_RDMSR:-0}" = "1" ]; then
    EXTRA_ARGS="$EXTRA_ARGS --randomx-no-rdmsr"
fi

if [ -n "${XMRIG_RANDOMX_MODE:-}" ]; then
    EXTRA_ARGS="$EXTRA_ARGS --randomx-mode=${XMRIG_RANDOMX_MODE}"
fi

log "Starting XMRig with Linux RandomX defaults: MSR enabled, Huge Pages JIT enabled, 1GB Huge Pages requested."

set -- \
    -a "${ALGO:-rx/0}" \
    -o "${POOL_ADDRESS:-stratum+ssl://pool.supportxmr.com:443}" \
    -u "${WALLET_USER:-YOUR_MONERO_WALLET}" \
    -p "${PASSWORD:-x}" \
    --http-enabled \
    --http-host=0.0.0.0 \
    --http-port="${API_PORT:-8080}" \
    --huge-pages-jit \
    --randomx-1gb-pages \
    "$@"

if [ -n "$EXTRA_ARGS" ]; then
    # shellcheck disable=SC2086
    set -- $EXTRA_ARGS "$@"
fi

exec xmrig "$@"