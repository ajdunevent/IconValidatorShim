#!/bin/bash

TARGET_FD=""
TARGET_PATH=""
RULESET="desktop"
POSITIONAL_ARGS=()

# parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --fd)
            TARGET_FD="$2"
            shift 2
            ;;
        --path=*)
            TARGET_PATH="${1#*=}"
            shift
            ;;
        --ruleset=*)
            RULESET="${1#*=}"
            shift
            ;;
        --sandbox)
            # ignore since we lack bwrap
            shift
            ;;
        -*)
            # Ignore other unknown flags
            shift
            ;;
        *)
            # Collect anything that isn't a flag as a positional argument
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# make educated guesses to assign non-flag arguments
for arg in "${POSITIONAL_ARGS[@]}"; do
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        if [ -z "$WIDTH" ]; then
            WIDTH="$arg"
        else
            HEIGHT="$arg"
        fi
    elif [[ "$arg" =~ ^(png|jpeg|jpg|svg)$ ]]; then
        FORMAT="$arg"
    fi
done

# id which source type was used
if [ -n "$TARGET_FD" ]; then
    SOURCE_ARG="--fd $TARGET_FD"
    PROBE_TARGET="/proc/self/fd/$TARGET_FD"
elif [ -n "$TARGET_PATH" ]; then
    SOURCE_ARG="--path=$TARGET_PATH"
    PROBE_TARGET="$TARGET_PATH"
else
    # if undetermined, allow to fail
    exec /usr/libexec/xdg-desktop-portal-validate-icon.orig "$@"
fi

# probe metadata for any missing requirements
if [ -z "$WIDTH" ] || [ -z "$HEIGHT" ] || [ -z "$FORMAT" ]; then
    IMAGE_INFO=$(file -bL "$PROBE_TARGET" 2>/dev/null)

    W=$(echo "$IMAGE_INFO" | grep -oP '\d+(?= x \d+)' | head -1)
    H=$(echo "$IMAGE_INFO" | grep -oP '(?<=\d x )\d+' | head -1)

    if [[ "$IMAGE_INFO" == *"PNG"* ]]; then F="png"
    elif [[ "$IMAGE_INFO" == *"JPEG"* ]]; then F="jpeg"
    elif [[ "$IMAGE_INFO" == *"SVG"* ]]; then F="svg"
    else F="png"; fi

    WIDTH=${WIDTH:-${W:-512}}
    HEIGHT=${HEIGHT:-${H:-512}}
    FORMAT=${FORMAT:-$F}
fi

# sanity check
if ! [[ "$WIDTH" =~ ^[0-9]+$ ]] || ! [[ "$HEIGHT" =~ ^[0-9]+$ ]]; then
    WIDTH=512
    HEIGHT=512
fi

# hand over to original executable
exec /usr/libexec/xdg-desktop-portal-validate-icon.orig --ruleset="$RULESET" $SOURCE_ARG "$WIDTH" "$HEIGHT" "$FORMAT"
