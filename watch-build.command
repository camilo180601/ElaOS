#!/bin/bash
# Sigue EN VIVO el build de las ISOs de ElaOS en GitHub Actions.
# Doble clic para abrir (o:  open watch-build.command).
cd "$(dirname "$0")" || exit 1
REPO="camilo180601/ElaOS"

while true; do
    clear
    echo "════════════════════════════════════════════════════════"
    echo "  ElaOS · seguimiento del build de las ISOs (amd64+arm64)"
    echo "  Repo: $REPO"
    echo "════════════════════════════════════════════════════════"
    echo

    RID="$(gh run list -R "$REPO" --workflow='Build ISO' --limit 1 \
        --json databaseId --jq '.[0].databaseId' 2>/dev/null)"

    if [ -z "$RID" ]; then
        echo "No encuentro runs. ¿Estás logueado? (gh auth status)"
        read -r -p "Enter para reintentar, Ctrl+C para salir... " _
        continue
    fi

    echo "▶ Siguiendo run $RID en vivo..."
    echo "  (https://github.com/$REPO/actions/runs/$RID)"
    echo
    gh run watch "$RID" -R "$REPO" --exit-status
    status=$?

    echo
    echo "════════════════════════════════════════════════════════"
    if [ "$status" -eq 0 ]; then
        echo "  ✅  BUILD OK — ambas ISOs generadas."
        echo "  Descargar:  gh run download $RID -R $REPO"
    else
        echo "  ❌  BUILD FALLÓ — errores:"
        echo "────────────────────────────────────────────────────────"
        gh run view "$RID" -R "$REPO" --log-failed 2>/dev/null \
            | grep -iE 'E:|error|fail|not found|404|unable|cannot|no such' \
            | grep -viE 'Configuring|warning:' \
            | tail -40
    fi
    echo "════════════════════════════════════════════════════════"
    echo
    read -r -p "Enter para seguir el próximo build · Ctrl+C para salir... " _
done
