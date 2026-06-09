#!/usr/bin/env bash
# Construye la ISO de ElaOS dentro de un contenedor Docker.
# Uso:  ./build.sh [amd64|arm64]
#   amd64  -> PC Intel/AMD  (en Mac Apple Silicon se emula: build más lento)
#   arm64  -> ARM / Apple Silicon (nativo en tu Mac, rápido)
set -euo pipefail

ARCH="${1:-amd64}"
IMAGE="elaos-builder"

case "$ARCH" in
  amd64|arm64) ;;
  *) echo "Arquitectura no válida: '$ARCH'. Usa: amd64 o arm64"; exit 1 ;;
esac

PLATFORM="linux/${ARCH}"

echo "==> [1/3] Construyendo el entorno de build (Docker, $PLATFORM)..."
docker build --platform "$PLATFORM" -t "$IMAGE" .

echo "==> [2/3] Generando la ISO de ElaOS para $ARCH (puede tardar; en amd64 emulado, 1-2h)..."
docker run --rm --privileged \
  --platform "$PLATFORM" \
  -v "$PWD:/build" \
  -e ELAOS_ARCH="$ARCH" \
  "$IMAGE" \
  bash -c "lb clean --purge || true; ./auto/config && lb build"

echo "==> [3/3] Listo."
if ls ./*.iso >/dev/null 2>&1; then
  ls -lh ./*.iso
else
  echo "No se encontró ninguna ISO. Revisa el log de arriba en busca de errores."
  exit 1
fi
