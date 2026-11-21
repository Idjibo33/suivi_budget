#!/usr/bin/env python3
"""Génère tous les assets d'identité MyBudget à partir d'une seule marque.

Le dessin est volontairement géométrique et simplifié : il reste lisible d'une
favicon 16x16 à l'icône 1024x1024 de l'App Store, et il ne dépend d'aucun
téléchargement au runtime. Les fichiers générés sont versionnés ; ce script
sert à les régénérer à l'identique (``pip install pillow`` suffit).
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

RACINE = Path(__file__).resolve().parent.parent

# Palette de la marque (identique à lib/constants.dart).
TEAL = (0, 121, 107, 255)
BLANC = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

SUR_ECHANTILLONNAGE = 4


def _boite(rect: tuple[float, float, float, float], taille: int) -> tuple[int, int, int, int]:
    """Convertit un rectangle normalisé (0..1) en pixels."""
    x0, y0, x1, y1 = rect
    return (round(x0 * taille), round(y0 * taille), round(x1 * taille), round(y1 * taille))


def _glyphe(taille: int) -> Image.Image:
    """Dessine le monogramme blanc sur fond transparent, en haute résolution."""
    image = Image.new("RGBA", (taille, taille), TRANSPARENT)
    d = ImageDraw.Draw(image)

    # Pièce au-dessus du portefeuille : flèche de croissance en teal.
    d.ellipse(_boite((0.32, 0.14, 0.68, 0.50), taille), fill=BLANC)
    epaisseur = max(2, round(taille * 0.028))
    d.line(
        [
            (round(0.43 * taille), round(0.37 * taille)),
            (round(0.50 * taille), round(0.29 * taille)),
            (round(0.57 * taille), round(0.37 * taille)),
        ],
        fill=TEAL,
        width=epaisseur,
        joint="curve",
    )
    d.line(
        [
            (round(0.50 * taille), round(0.29 * taille)),
            (round(0.50 * taille), round(0.43 * taille)),
        ],
        fill=TEAL,
        width=epaisseur,
    )

    # Corps du portefeuille.
    d.rounded_rectangle(
        _boite((0.16, 0.45, 0.84, 0.78), taille),
        radius=round(taille * 0.075),
        fill=BLANC,
    )
    # Fente et bouton, en teal pour garder le contraste.
    d.rounded_rectangle(
        _boite((0.26, 0.53, 0.56, 0.58), taille),
        radius=round(taille * 0.015),
        fill=TEAL,
    )
    d.ellipse(_boite((0.67, 0.605, 0.76, 0.695), taille), fill=TEAL)
    return image


def glyphe(taille: int) -> Image.Image:
    """Glyphe blanc antialiased à la taille demandée."""
    grand = taille * SUR_ECHANTILLONNAGE
    return _glyphe(grand).resize((taille, taille), Image.Resampling.LANCZOS)


def tuile(taille: int, *, masquable: bool = False) -> Image.Image:
    """Construit l'icône complète (fond teal + glyphe)."""
    image = Image.new("RGBA", (taille, taille), TRANSPARENT)
    d = ImageDraw.Draw(image)
    if masquable:
        # Fond plein : les bords seront masqués par le launcher.
        d.rectangle((0, 0, taille - 1, taille - 1), fill=TEAL)
    else:
        d.rounded_rectangle(
            (0, 0, taille - 1, taille - 1),
            radius=round(taille * 0.22),
            fill=TEAL,
        )

    marque = glyphe(taille)
    if masquable:
        # Zone de sécurité : le glyphe reste dans les 80 % centraux.
        cote = round(taille * 0.80)
        marque = marque.resize((cote, cote), Image.Resampling.LANCZOS)
        marge = round(taille * 0.10)
        image.alpha_composite(marque, (marge, marge))
    else:
        image.alpha_composite(marque, (0, 0))
    return image


def ecrit(image: Image.Image, chemin: str) -> None:
    cible = RACINE / chemin
    cible.parent.mkdir(parents=True, exist_ok=True)
    image.save(cible)
    print(f"  {chemin} ({image.width}x{image.height})")


def main() -> None:
    print("Assets de marque MyBudget :")

    # Marque utilisée dans l'application (glyphe blanc seul) et sa tuile.
    ecrit(glyphe(512), "assets/images/logo_foreground.png")
    ecrit(tuile(512), "assets/images/logo.png")

    # Web / PWA.
    ecrit(tuile(16), "web/favicon.png")
    ecrit(tuile(180), "web/icons/apple-touch-icon.png")
    ecrit(tuile(192), "web/icons/Icon-192.png")
    ecrit(tuile(512), "web/icons/Icon-512.png")
    ecrit(tuile(192, masquable=True), "web/icons/Icon-maskable-192.png")
    ecrit(tuile(512, masquable=True), "web/icons/Icon-maskable-512.png")

    # Android : icônes legacy (carrée + ronde).
    for nom, taille in [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96),
                        ("xxhdpi", 144), ("xxxhdpi", 192)]:
        icone = tuile(taille)
        ecrit(icone, f"android/app/src/main/res/mipmap-{nom}/ic_launcher.png")
        ecrit(icone, f"android/app/src/main/res/mipmap-{nom}/ic_launcher_round.png")

    # Android : icônes adaptatives (foreground dans la zone de sécurité).
    for nom, taille in [("mdpi", 108), ("hdpi", 162), ("xhdpi", 216),
                        ("xxhdpi", 324), ("xxxhdpi", 432)]:
        ecrit(
            glyphe(taille),
            f"android/app/src/main/res/mipmap-{nom}/ic_launcher_foreground.png",
        )

    # iOS.
    appicon = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for nom, taille in [
        ("Icon-App-20x20@1x.png", 20), ("Icon-App-20x20@2x.png", 40),
        ("Icon-App-20x20@3x.png", 60), ("Icon-App-29x29@1x.png", 29),
        ("Icon-App-29x29@2x.png", 58), ("Icon-App-29x29@3x.png", 87),
        ("Icon-App-40x40@1x.png", 40), ("Icon-App-40x40@2x.png", 80),
        ("Icon-App-40x40@3x.png", 120), ("Icon-App-60x60@2x.png", 120),
        ("Icon-App-60x60@3x.png", 180), ("Icon-App-76x76@1x.png", 76),
        ("Icon-App-76x76@2x.png", 152), ("Icon-App-83.5x83.5@2x.png", 167),
        ("Icon-App-1024x1024@1x.png", 1024),
    ]:
        ecrit(tuile(taille), f"{appicon}/{nom}")

    # iOS : images de lancement (le storyboard attend un carré 168x185 pts).
    lance = "ios/Runner/Assets.xcassets/LaunchImage.imageset"
    for nom, taille in [
        ("LaunchImage.png", (168, 185)),
        ("LaunchImage@2x.png", (336, 370)),
        ("LaunchImage@3x.png", (504, 555)),
    ]:
        grand = Image.new("RGBA", (taille[0] * 4, taille[1] * 4), TRANSPARENT)
        cote = round(min(grand.size) * 0.62)
        marque = _glyphe(cote)
        grand.alpha_composite(
            marque, ((grand.width - cote) // 2, (grand.height - cote) // 2)
        )
        ecrit(grand.resize(taille, Image.Resampling.LANCZOS), f"{lance}/{nom}")

    # Windows : plusieurs tailles dans un seul .ico.
    tailles_ico = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
    cible = RACINE / "windows/runner/resources/app_icon.ico"
    cible.parent.mkdir(parents=True, exist_ok=True)
    tuile(256).save(cible, sizes=tailles_ico)
    print(f"  windows/runner/resources/app_icon.ico {tailles_ico}")

    # Linux : icône installée dans le thème hicolor.
    ecrit(tuile(512), "linux/runner/resources/icons/hicolor/512x512/apps/com.mybudget.app.png")


if __name__ == "__main__":
    main()
