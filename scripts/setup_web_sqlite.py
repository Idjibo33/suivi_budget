#!/usr/bin/env python3
"""Prépare les binaires SQLite/Web compatibles avec les dépendances du projet.

``sqflite_common_ffi_web`` télécharge un ``sqlite3.wasm`` figé (2.4.6) qui ne
correspond pas à la version de ``sqlite3`` résolue par ``pub get`` (3.9.1). Le
chargeur Dart fournit l'import WebAssembly ``dart`` alors que l'ancien binaire
attend ``env`` : ``getDatabasesPath()`` échoue alors et l'application reste
bloquée sur un écran vide.

Le script construit le worker partagé avec les versions installées, puis
remplace le wasm par celui de la release du même numéro de version que le
package Dart.
"""

from __future__ import annotations

import re
import subprocess
import urllib.request
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
LOCK = RACINE / "pubspec.lock"
WEB = RACINE / "web"
RELEASES = "https://github.com/simolus3/sqlite3.dart/releases/download"


def version_sqlite3() -> str:
    """Lit la version de sqlite3 résolue dans pubspec.lock."""
    lignes = LOCK.read_text(encoding="utf-8").splitlines()
    for index, ligne in enumerate(lignes):
        if ligne == "  sqlite3:":
            for suivante in lignes[index + 1 : index + 12]:
                correspondance = re.match(r'\s+version: "([^"]+)"', suivante)
                if correspondance:
                    return correspondance.group(1)
            break
    raise RuntimeError("Version de sqlite3 introuvable dans pubspec.lock")


def main() -> None:
    version = version_sqlite3()
    # Construit sqflite_sw.js avec la version de sqflite_common_ffi_web installée.
    subprocess.run(
        ["dart", "run", "sqflite_common_ffi_web:setup", "--force"],
        cwd=RACINE,
        check=True,
    )
    # Remplace le wasm figé par celui de la version réellement utilisée.
    url = f"{RELEASES}/sqlite3-{version}/sqlite3.wasm"
    destination = WEB / "sqlite3.wasm"
    with urllib.request.urlopen(url) as reponse:  # noqa: S310 - URL fixe
        donnees = reponse.read()
    if not donnees.startswith(b"\x00asm"):
        raise RuntimeError(f"Wasm invalide téléchargé depuis {url}")
    destination.write_bytes(donnees)
    print(f"SQLite Web prêt : worker sqflite_sw.js + sqlite3.wasm ({version})")


if __name__ == "__main__":
    main()
