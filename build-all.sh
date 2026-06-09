#!/usr/bin/env bash
# Construye las DOS ISOs de ElaOS (amd64 y arm64) de forma secuencial,
# las renombra a ElaOS-<arch>.iso y genera su SHA256.
#
# Uso:   ./build-all.sh
# Arsenal:  ELAOS_KALI_META=kali-tools-top10 ./build-all.sh   (por defecto: kali-linux-default)
# Subset:   ELAOS_ARCHES="arm64" ./build-all.sh               (solo una)
#
# Nota: en un Mac Apple Silicon, el build amd64 se emula y es LENTO.
#       Para ambas arquitecturas en máquinas nativas, usa el CI de GitHub Actions.
set -euo pipefail
cd "$(dirname "$0")"

read -ra ARCHES <<< "${ELAOS_ARCHES:-amd64 arm64}"
KALI_META="${ELAOS_KALI_META:-kali-linux-default}"

sha256() { command -v sha256sum >/dev/null 2>&1 && sha256sum "$1" || shasum -a 256 "$1"; }

echo "==> ElaOS · construyendo: ${ARCHES[*]}  (arsenal: ${KALI_META})"
built=()
for arch in "${ARCHES[@]}"; do
    echo
    echo "################  ElaOS ${arch}  ################"
    ELAOS_KALI_META="$KALI_META" ./build.sh "$arch"

    iso="$(ls -t live-image-*.iso 2>/dev/null | head -n1 || true)"
    if [ -z "$iso" ]; then
        echo "!! No se generó ISO para ${arch}; abortando."
        exit 1
    fi
    out="ElaOS-${arch}.iso"
    mv -f "$iso" "$out"
    sha256 "$out" > "${out}.sha256"
    built+=("$out")
    echo "==> Generada: ${out}"
done

echo
echo "==> ISOs finales:"
ls -lh "${built[@]}"
