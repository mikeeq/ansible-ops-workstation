#!/usr/bin/env python3
"""Gate open/closed from a camera snapshot (shell_command.brama_obraz, automations/bramy.yaml).

Usage: brama_obraz.py <tryb> <brama> <obraz> <x0> <y0> <x1> <y1>
  tryb:  klasyfikuj                     – compare the gate area with both references
         wzorzec_open | wzorzec_closed  – offer the gate area as the reference for that state (automatic learning:
                                          kept only if there is no reference yet or the crop already classifies
                                          as that state, so a wrong model cannot teach wrong references)
         zapisz_open | zapisz_closed    – save the reference unconditionally (script.brama_wzorzec)
         reset                          – delete the references of <brama> (obraz/x0..y1 are ignored)
  brama: gate id + camera mode, e.g. wjazdowa_day
  x0..x1: gate area as fractions of the frame

The crop is grey-scaled, scaled down and histogram-equalised (lighting), then compared with each reference by
normalised cross-correlation of the image and of its edges. Prints JSON: {"stan": open|closed|niepewny|brak_wzorca,
"open": score, "closed": score}. Pillow only (bundled with Home Assistant).
"""

import json
import math
import sys
from pathlib import Path

from PIL import Image, ImageFilter, ImageOps

KATALOG = Path("/config/tmp")
ROZMIAR = (96, 40)
PEWNY = 0.6  # the winning reference must match at least this well
MARGINES = 0.2  # ... and this much better than the other one
JEDEN_WZORZEC = 0.3  # only one reference: below = clearly the other state


def wycinek(obraz: Path, roi: list[float]) -> Image.Image:
    img = Image.open(obraz).convert("L")
    w, h = img.size
    x0, y0, x1, y1 = roi
    box = (int(x0 * w), int(y0 * h), int(x1 * w), int(y1 * h))
    return ImageOps.equalize(img.crop(box).resize(ROZMIAR, Image.Resampling.BILINEAR))


def ncc(a: Image.Image, b: Image.Image) -> float:
    da, db = list(a.tobytes()), list(b.tobytes())
    ma, mb = sum(da) / len(da), sum(db) / len(db)
    num = sum((x - ma) * (y - mb) for x, y in zip(da, db))
    den = math.sqrt(sum((x - ma) ** 2 for x in da) * sum((y - mb) ** 2 for y in db))
    return num / den if den else 0.0


def podobienstwo(a: Image.Image, b: Image.Image) -> float:
    krawedzie = ncc(a.filter(ImageFilter.FIND_EDGES), b.filter(ImageFilter.FIND_EDGES))
    return round((ncc(a, b) + krawedzie) / 2, 3)


def wzorzec(brama: str, stan: str) -> Path:
    return KATALOG / f"brama_{brama}_wzorzec_{stan}.png"


def klasyfikuj(crop: Image.Image, brama: str) -> dict[str, object]:
    wynik: dict[str, object] = {}
    for stan in ("open", "closed"):
        if wzorzec(brama, stan).exists():
            wynik[stan] = podobienstwo(crop, Image.open(wzorzec(brama, stan)))

    if len(wynik) == 2:
        o, c = wynik["open"], wynik["closed"]
        if c >= PEWNY and c - o >= MARGINES:
            wynik["stan"] = "closed"
        elif o >= PEWNY and o - c >= MARGINES:
            wynik["stan"] = "open"
        else:
            wynik["stan"] = "niepewny"
    elif len(wynik) == 1:
        ((stan, s),) = wynik.items()
        inny = "closed" if stan == "open" else "open"
        wynik["stan"] = (
            stan if s >= PEWNY else inny if s <= JEDEN_WZORZEC else "niepewny"
        )
    else:
        wynik["stan"] = "brak_wzorca"
    return wynik


def main() -> int:
    if len(sys.argv) != 8:
        print(
            json.dumps({"stan": "blad", "blad": "usage: tryb brama obraz x0 y0 x1 y1"})
        )
        return 2
    tryb, brama, obraz = sys.argv[1], sys.argv[2], Path(sys.argv[3])

    if tryb == "reset":
        usuniete = [p.name for p in KATALOG.glob(f"brama_{brama}_wzorzec_*.png")]
        for nazwa in usuniete:
            (KATALOG / nazwa).unlink()
        print(json.dumps({"stan": "reset", "usuniete": usuniete}))
        return 0

    crop = wycinek(obraz, [float(v) for v in sys.argv[4:8]])

    if tryb.startswith(("wzorzec_", "zapisz_")):
        stan = tryb.split("_", 1)[1]
        if tryb.startswith("wzorzec_") and wzorzec(brama, stan).exists():
            teraz = klasyfikuj(crop, brama)
            if teraz["stan"] != stan:
                print(
                    json.dumps({"stan": "odrzucono", "wzorzec": stan, "wynik": teraz})
                )
                return 0
        crop.save(wzorzec(brama, stan))
        print(json.dumps({"stan": "zapisano", "wzorzec": stan}))
        return 0

    crop.save(KATALOG / f"brama_{brama}_ostatni.png")
    print(json.dumps(klasyfikuj(crop, brama)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
