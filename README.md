# ElaOS

**The desktop, refined.** Distribución Linux con **apariencia macOS** (estable,
pulida, intuitiva), el **arsenal de ciberseguridad de Kali** y una **capa de
gaming** — todo en una sola ISO, con modos intercambiables como si fueran un tema.

[![Build ISO](https://github.com/camilo180601/ElaOS/actions/workflows/build-iso.yml/badge.svg)](https://github.com/camilo180601/ElaOS/actions/workflows/build-iso.yml)

- **Base:** Kali Rolling (Debian por dentro) → acceso a todo el arsenal Kali.
- **Escritorio:** GNOME + tema **WhiteSur** (macOS Big Sur), iconos WhiteSur,
  cursores McMojave, dock inferior, botones de ventana a la izquierda.
- **Seguridad:** arsenal Kali configurable (`top10` / `default` / `everything`).
- **Gaming (siempre activo):** Steam y Lutris fijos en el dock, Wine, GameMode,
  MangoHud y drivers Vulkan/Mesa instalados de forma permanente. Puedes abrir un
  juego y jugar **en cualquier modo**; no hay que "activar" nada.
- **Desarrollo:** PHP/Composer (Laravel), Node, Docker, VS Code, .NET SDK.
- **Modos:** `elaos-mode {normal|gaming|hacking}` muestra/oculta la capa de
  seguridad y ajusta el rendimiento. Las herramientas siempre están instaladas.
- **Construcción:** `live-build` en Docker (reproducible, versionable) + CI que
  genera **ambas arquitecturas** (`amd64` y `arm64`).

## Construir / descargar la ISO

### En la nube (recomendado) — GitHub Actions

El workflow [`.github/workflows/build-iso.yml`](.github/workflows/build-iso.yml)
construye **amd64 y arm64** en runners nativos (sin emulación). Dispáralo desde
**Actions → Build ISO → Run workflow** (eliges el arsenal: top10/default/everything),
o publica un tag `vX.Y` para generar las ISOs y subirlas a un Release.

Descargar las ISOs de un run terminado:

```bash
gh run download <run-id> -R camilo180601/ElaOS
# genera ElaOS-amd64.iso y ElaOS-arm64.iso (+ .sha256)
```

> El arsenal `everything` puede no caber en los runners gratuitos (disco/tiempo);
> usa `default`/`top10` en CI o un runner self-hosted x86 grande.

### Local (Docker)

```bash
./build-all.sh      # AMBAS ISOs (amd64 + arm64) → ElaOS-<arch>.iso + .sha256

./build.sh amd64    # solo PC Intel/AMD (en Mac M-series se emula: lento)
./build.sh arm64    # solo ARM / Apple Silicon (nativo, rápido)

# Tamaño del arsenal (por defecto kali-linux-default):
ELAOS_KALI_META=kali-tools-top10      ./build.sh arm64
ELAOS_KALI_META=kali-linux-everything ./build.sh amd64
```

La ISO queda en la raíz del proyecto. La lista de paquetes Kali se **genera** en
cada build a partir de `ELAOS_KALI_META` (no se versiona).

**Requisitos:** Docker en ejecución y 20–60 GB libres (según el arsenal).

### Seguir el build en vivo

`./watch-build.command` (doble clic en macOS) abre una terminal que sigue el
último build de GitHub Actions paso a paso y muestra los errores si falla.

## ElaOS Terminal

Identidad propia: **Kitty** (emulador GPU, estilo macOS) + **Starship** (prompt con
la paleta de marca morado→coral) + **fastfetch** (bienvenida con el logo).

- **Asistente al primer arranque** (`elaos-term-setup`): elige fondo (oscuro/claro)
  y color de acento (presets de marca o un hex propio); se aplica al instante.
- Tema claro/oscuro: `elaos-term-theme dark|light` (alias `tema`).
- Personalizable: `~/.config/kitty/kitty.conf`, `~/.config/starship.toml`,
  temas en `/usr/share/elaos/kitty-themes/`.
- Aliases: `ll`, `lt` (eza), `cat` (bat), `modo` (= `elaos-mode`), `tema`.

## Los tres modos

> El **gaming está siempre disponible**, independientemente del modo. Los modos
> solo controlan la capa de seguridad y el perfil de rendimiento.

Desde el **botón de la barra superior**, la **app de bienvenida**, o por terminal
(por-usuario, sin sudo):

```bash
elaos-mode hacking   # muestra el arsenal de seguridad en el menú
elaos-mode gaming    # oculta seguridad; rendimiento al máximo
elaos-mode normal    # escritorio macOS limpio
elaos-mode status    # modo actual
```

## Onboarding

- **Bienvenida al primer arranque** (`elaos-welcome`): elige modo y abre la
  terminal. Se muestra una vez; relanzable desde el menú de apps.
- **Switch de modos** en la barra superior (extensión GNOME `elaos-modes@elaos`).

## Capa de desarrollo (fullstack)

**PHP + Composer** (Laravel), **Node/npm**, **Docker**, clientes MySQL/SQLite,
**VS Code** y **.NET SDK** (LTS). Instalador de Laravel por usuario:

```bash
composer global require laravel/installer
```

## Branding completo

Logo propio de ElaOS en toda la cadena: **GRUB** → **Plymouth** (splash) →
**GDM** (login) → **escritorio** (wallpapers de marca, degradado morado→coral) →
**Calamares** (instalador con marca y slideshow).

## Estructura

```
ElaOS/
├── build.sh / build-all.sh         # Construye una / ambas ISOs vía Docker
├── watch-build.command             # Sigue el build de CI en vivo (macOS)
├── Dockerfile                      # Entorno de build (Kali Rolling + live-build)
├── auto/config                     # Config reproducible de live-build
├── assets/branding/                # Logos (logo-light/dark.png)
├── .github/workflows/build-iso.yml # CI: ISOs amd64 + arm64
└── config/
    ├── package-lists/              # desktop, branding, gaming, terminal,
    │                               #   onboarding, dev, installer
    ├── hooks/normal/
    │   ├── 0100-macos-theme        → WhiteSur, iconos, cursores, dock, login GDM
    │   ├── 0150-wallpapers         → wallpapers de marca (ImageMagick)
    │   ├── 0200-gaming             → multiarch i386 + Steam + Wine (amd64)
    │   ├── 0300-plymouth           → splash de arranque con logo
    │   ├── 0400-terminal           → starship + Nerd Font + kitty/zsh
    │   ├── 0600-calamares          → branding del instalador
    │   ├── 0610-grub-theme         → tema de GRUB
    │   ├── 0700-dev                → VS Code + .NET + Docker compose
    │   └── 0900-enforce-macos-look → reafirma el look macOS sobre Kali
    └── includes.chroot/
        ├── usr/local/bin/          → elaos-mode, elaos-welcome, elaos-term-*
        ├── usr/share/elaos/        → logos, temas de terminal
        ├── usr/share/gnome-shell/extensions/elaos-modes@elaos/
        └── etc/                    → os-release, dconf, gamemode.ini, calamares…
```

## Roadmap

- [x] Pipeline de build (live-build en Docker) + **CI amd64/arm64 funcionando**
- [x] **Primer build exitoso en CI** (ambas ISOs generadas)
- [x] Capa de ciberseguridad (arsenal Kali) + toggle de modos por-usuario
- [x] Capa de gaming siempre activa (Steam/Lutris/Wine/GameMode)
- [x] Branding completo: GRUB, Plymouth, GDM, wallpapers, Calamares
- [x] App de bienvenida + switch de modos en la barra (extensión GNOME)
- [x] Capa de desarrollo fullstack (PHP/Composer, Node, Docker, VS Code, .NET)
- [x] ElaOS Terminal (kitty + starship + fastfetch) con asistente
- [ ] **Afinar el tema WhiteSur en el build** (deps del install.sh) ← en curso
- [ ] Validar la extensión de modos contra la versión de GNOME de Kali
- [ ] Probar `everything` en runner x86 grande
- [ ] Repo APT propio + meta-paquete `elaos-desktop`

## Notas técnicas

- **Modo oscuro/claro del escritorio:** WhiteSur trae `WhiteSur-Light` /
  `WhiteSur-Dark`; se cambian desde Configuración → Apariencia.
- **Look macOS sobre Kali:** los defaults de apariencia (`zzz-elaos-*.gschema.override`
  + `etc/dconf/db/local.d/00-elaos`) se reafirman en el hook `0900` para ganar a
  cualquier branding de Kali.
- **Hooks resilientes:** las descargas de temas/fuentes reintentan y no abortan el
  build; un fallo deja warning y la ISO se genera igual.
```
