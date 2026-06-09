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

## Los tres modos

```bash
sudo elaos-mode hacking   # muestra el arsenal de seguridad en el menú
sudo elaos-mode gaming    # oculta seguridad; escritorio listo para jugar
sudo elaos-mode normal    # escritorio macOS limpio
elaos-mode status         # modo actual
```

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
    │   └── installer.list.chroot    → Calamares
    ├── hooks/normal/
    │   ├── 0100-macos-theme...      → WhiteSur, iconos, cursores, dock
    │   └── 0200-gaming...           → multiarch i386 + Steam + Wine (amd64)
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
- [x] Tema de login GDM macOS (WhiteSur) + splash de arranque limpio (Plymouth)
- [ ] Logo propio de ElaOS en el splash de arranque (ahora usa 'spinner')
- [ ] Probar el build real en x86_64 y validar metapaquetes
- [ ] Afinar `elaos-mode` (verificar el <Name> del menú Kali tras el primer build)
- [ ] Instalador Calamares con branding propio
- [ ] GUI para el cambio de modos (botón en la barra superior)
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
