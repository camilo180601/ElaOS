# ElaOS

Distribución Linux con **apariencia macOS** (estable, pulida, intuitiva), el
**arsenal de ciberseguridad de Kali** y una **capa de gaming** — todo en una sola
ISO, con tres modos intercambiables como si fueran un tema.

- **Base:** Kali Rolling (Debian por dentro) → da acceso a todo el arsenal Kali.
- **Escritorio:** GNOME + tema **WhiteSur** (macOS Big Sur), iconos WhiteSur,
  cursores McMojave, dock inferior, botones de ventana a la izquierda.
- **Seguridad:** `kali-linux-everything` (todo el arsenal de Kali).
- **Gaming:** Steam, Lutris, Wine, GameMode, MangoHud, drivers Vulkan/Mesa.
- **Modos:** `elaos-mode {normal|gaming|hacking}` enciende/apaga la capa de
  seguridad en el menú. Las herramientas siempre están instaladas; el modo solo
  cambia la experiencia.
- **Construcción:** `live-build` dentro de Docker (reproducible, versionable en Git).
- **Arquitecturas:** `amd64` (PC; gaming completo) y `arm64` (ARM/Apple Silicon;
  sin Steam/Wine i386).

## ⚠️ Aviso importante sobre el build de "everything"

`kali-linux-everything` produce una ISO **enorme (15 GB+)** y un build muy largo.
**Construirlo bajo emulación amd64 en un Mac Apple Silicon es inviable** (horas,
decenas de GB, alto riesgo de fallo). Recomendado:

- **Para probar:** edita [`config/package-lists/kali-tools.list.chroot`](config/package-lists/kali-tools.list.chroot)
  y cambia `kali-linux-everything` por `kali-linux-default` o `kali-tools-top10`.
- **Para "everything":** construye en un **x86_64 real** o una **VM en la nube**
  (más RAM/CPU/disco), no en el Mac emulado.

## Requisitos

- Docker Desktop instalado y **en ejecución**.
- 20–60 GB libres de disco (según el set de herramientas) y buena conexión.

## Construir la ISO

```bash
./build.sh amd64    # PC Intel/AMD — gaming + seguridad completos
./build.sh arm64    # ARM / Apple Silicon — nativo, sin Steam/Wine
```

## ElaOS Terminal

Terminal con identidad propia: **Kitty** (emulador GPU, estilo macOS) + **Starship**
(prompt con la paleta de marca morado→coral) + **fastfetch** (bienvenida con el logo).

- **Asistente al primer arranque:** la primera vez que abres la terminal,
  `elaos-term-setup` te deja elegir fondo (oscuro/claro) y color de acento
  (presets de marca o un hex propio) y lo aplica al instante. Relánzalo cuando
  quieras con `elaos-term-setup`.
- Tema claro/oscuro alternable:
  ```bash
  elaos-term-theme dark    # o: tema dark
  elaos-term-theme light   # o: tema light
  ```
- Totalmente personalizable: edita `~/.config/kitty/kitty.conf` (fuente, opacidad,
  blur, padding), `~/.config/starship.toml` (prompt) y los temas de color en
  `/usr/share/elaos/kitty-themes/`.
- Atajos: `Ctrl+Shift+T` nueva pestaña, `Ctrl+Shift+Enter` nueva ventana,
  `Ctrl+Shift +/-` tamaño de fuente.
- Aliases incluidos: `ll`, `lt` (eza), `cat` (bat), `modo` (= `sudo elaos-mode`),
  `tema` (= `elaos-term-theme`).

## Los tres modos

Desde el **botón de la barra superior** (extensión ElaOS Modes), desde la
**app de bienvenida**, o por terminal (es por-usuario, sin sudo):

```bash
elaos-mode hacking   # muestra el arsenal de seguridad en el menú
elaos-mode gaming    # oculta seguridad; escritorio listo para jugar
elaos-mode normal    # escritorio macOS limpio
elaos-mode status    # modo actual
```

## Onboarding

- **Bienvenida al primer arranque** (`elaos-welcome`): elige modo y abre la
  terminal. Se muestra una sola vez; relanzable desde el menú de apps.
- **Switch de modos** en la barra superior (extensión GNOME `elaos-modes@elaos`).

## Capa de desarrollo (fullstack)

Incluida: **PHP + Composer** (Laravel), **Node/npm**, **Docker**, clientes de
MySQL/SQLite, **VS Code** y **.NET SDK** (LTS). Instala el instalador de Laravel
por usuario con:

```bash
composer global require laravel/installer
```

## Branding completo

Logo propio de ElaOS en toda la cadena: **GRUB** (tema de arranque) → **Plymouth**
(splash) → **GDM** (login) → **escritorio** (wallpapers de marca generados con el
degradado morado→coral) → **Calamares** (instalador con marca y slideshow).

## Estructura

```
ElaOS/
├── build.sh                       # Construye la ISO vía Docker
├── Dockerfile                     # Entorno de build (Kali Rolling + live-build)
├── auto/config                    # Config reproducible de live-build
└── config/
    ├── package-lists/
    │   ├── desktop.list.chroot      → GNOME + apps base
    │   ├── branding.list.chroot     → deps de los temas macOS
    │   ├── kali-tools.list.chroot   → arsenal de seguridad (everything)
    │   ├── gaming.list.chroot       → Lutris, GameMode, MangoHud, Vulkan
    │   ├── terminal.list.chroot     → kitty, fastfetch, zsh
    │   └── installer.list.chroot    → Calamares
    ├── hooks/normal/
    │   ├── 0100-macos-theme...      → WhiteSur, iconos, cursores, dock, login GDM
    │   ├── 0200-gaming...           → multiarch i386 + Steam + Wine (amd64)
    │   ├── 0300-plymouth...         → splash de arranque ElaOS
    │   ├── 0400-terminal...         → starship + Nerd Font + kitty/zsh por defecto
    │   └── 0900-enforce-macos-look  → reafirma el look macOS sobre Kali
    └── includes.chroot/
        ├── usr/local/bin/elaos-mode → toggle normal/gaming/hacking
        └── etc/
            ├── os-release           → branding ElaOS
            └── dconf/               → apariencia por defecto (tema, dock, wallpaper)
```

## Roadmap

- [x] ISO live con look macOS (GNOME + WhiteSur)
- [x] Capa de ciberseguridad (arsenal Kali) + toggle de modos
- [x] Capa de gaming (Steam/Lutris/Wine/GameMode)
- [x] Blindaje del look macOS sobre Kali (override + hook 0900)
- [x] Tema de login GDM macOS (WhiteSur) + splash de arranque con logo propio
- [x] Logo propio en el splash (Plymouth) y tema de GRUB con marca
- [x] Wallpapers de marca generados (degradado morado→coral)
- [x] Instalador Calamares con branding ElaOS + slideshow
- [x] App de bienvenida + switch de modos en la barra superior (extensión GNOME)
- [x] Capa de desarrollo fullstack (PHP/Composer, Node, Docker, VS Code, .NET)
- [ ] Probar el build real en x86_64 y validar metapaquetes
- [ ] Afinar `elaos-mode` (verificar el <Name> del menú Kali tras el primer build)
- [ ] CI que genere ISOs + repo APT propio
- [ ] Repositorio APT propio + meta-paquete `elaos-desktop`

## Notas técnicas

- **Modo oscuro/claro:** WhiteSur trae ambas variantes (`WhiteSur-Light` /
  `WhiteSur-Dark`); se cambian desde Configuración → Apariencia.
- **Kali defaults vs. look macOS:** `kali-linux-everything` puede arrastrar
  ajustes/branding de Kali; nuestros defaults de apariencia están en
  `etc/dconf/db/local.d/00-elaos`. Si tras el build el look no se respeta,
  hay que reforzar la precedencia del perfil dconf.
- **Multi-DE:** `everything` puede instalar varios escritorios; GNOME queda como
  sesión por defecto vía gdm3.
