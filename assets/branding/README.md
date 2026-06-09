# Branding de ElaOS — logos

Guarda aquí las dos variantes del logo (las que diseñaste):

| Archivo | Variante | Uso |
|---|---|---|
| `logo-light.png` | Texto **claro** ("Ela" blanco) | Fondos oscuros: splash de arranque, login |
| `logo-dark.png`  | Texto **oscuro** ("Ela" gris/negro) | Fondos claros: web, documentación |

**Formato recomendado:** PNG con fondo transparente, ~1200 px de ancho.

## Dónde se usan (ya está cableado)

- **Splash de arranque (Plymouth):** se usa `logo-light.png` copiado a
  `config/includes.chroot/usr/share/plymouth/themes/elaos/logo.png`.
  El hook `0300-plymouth` activa el tema ElaOS solo si ese archivo existe;
  si falta, cae a `spinner`.

## Cómo instalarlos (una vez guardados aquí)

```bash
# Desde la raíz del proyecto:
cp assets/branding/logo-light.png \
   config/includes.chroot/usr/share/plymouth/themes/elaos/logo.png
```

Luego reconstruye la ISO (`./build.sh amd64`) y el arranque mostrará tu logo.
