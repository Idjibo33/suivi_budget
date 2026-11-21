#!/usr/bin/env python3
"""Patche le build Web Flutter pour le flavor dev.

.myBudget utilise le même code source pour prod et dev ; seule l'identité
affichée change. Ce script ajuste le titre, le manifeste et la couleur de
theme du dossier de build généré, sans toucher aux sources versionnées.

Usage : python3 scripts/patch_web_dev.py [dossier_build]  (défaut : build/web)
"""

import json
import sys
from pathlib import Path

NOM_PROD = "MyBudget"
NOM_DEV = "MyBudget Dev"
COULEUR_PROD = "#00796B"
COULEUR_DEV = "#00695C"


def patcher_index(index: Path) -> None:
    contenu = index.read_text(encoding="utf-8")
    remplacements = {
        f"<title>{NOM_PROD}</title>": f"<title>{NOM_DEV}</title>",
        f'apple-mobile-web-app-title" content="{NOM_PROD}"': (
            f'apple-mobile-web-app-title" content="{NOM_DEV}"'
        ),
        f'theme-color" content="{COULEUR_PROD}"': (
            f'theme-color" content="{COULEUR_DEV}"'
        ),
        f'name="description" content="{NOM_PROD}': (
            f'name="description" content="{NOM_DEV}'
        ),
    }
    for ancien, nouveau in remplacements.items():
        if ancien not in contenu:
            raise SystemExit(f"[patch_web_dev] motif introuvable dans index.html : {ancien}")
        contenu = contenu.replace(ancien, nouveau)
    index.write_text(contenu, encoding="utf-8")


def patcher_manifest(manifest: Path) -> None:
    donnees = json.loads(manifest.read_text(encoding="utf-8"))
    if donnees.get("name") != NOM_PROD or donnees.get("short_name") != NOM_PROD:
        raise SystemExit("[patch_web_dev] identité inattendue dans manifest.json")
    donnees["name"] = NOM_DEV
    donnees["short_name"] = NOM_DEV
    donnees["theme_color"] = COULEUR_DEV
    manifest.write_text(
        json.dumps(donnees, ensure_ascii=False, indent=4) + "\n", encoding="utf-8"
    )


def main() -> None:
    dossier = Path(sys.argv[1] if len(sys.argv) > 1 else "build/web")
    patcher_index(dossier / "index.html")
    patcher_manifest(dossier / "manifest.json")
    print(f"[patch_web_dev] build Web patché pour {NOM_DEV} dans {dossier}")


if __name__ == "__main__":
    main()
