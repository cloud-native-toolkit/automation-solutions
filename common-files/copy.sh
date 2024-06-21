 #!/usr/bin/env sh

SOURCE1_VAL="${1:-$SOURCE1}"
TARGET_VAL="${2:-$TARGET}"

mkdir -p "${TARGET_VAL}"

cp -pLvR "${SOURCE1_VAL}"/* "${TARGET_VAL}"
if [ -n "${SOURCE2}" ]; then
  cp -pLvR "${SOURCE2}"/* "${TARGET_VAL}"
fi
if [ -n "${SOURCE3}" ]; then
  cp -pLvR "${SOURCE3}"/* "${TARGET_VAL}"
fi

if [ -n "${OWNER}" ]; then
  chown -vR "${OWNER}:root" "${TARGET_VAL}"/*
fi
