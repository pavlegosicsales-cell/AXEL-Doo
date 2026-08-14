"""
gen_terrain_svg.py  /  AXEL

Crta profil iskopa sa kaskadama, u ISTOJ tackastoj mrezi kao mapa sveta i
tipovi objekata u sekciji O nama. Bez toga bi tri kartice izgledale kao tri
razne slike umesto kao jedna porodica.

Mreza je preuzeta iz izlaza dotted-map biblioteke, koji je vec u
site/assets/img/mapa-sveta.svg:
    viewBox   0 0 99 50
    korak x   1.0, redovi pomereni za 0.5
    razmak    sqrt(3)/2 po y
    r         0.3, akcenat r 0.42

Izlaz: site/assets/img/profil-iskopa.svg
Pokretanje: python tools/gen_terrain_svg.py
"""

import math
import os

STEP_X = 1.0
STEP_Y = math.sqrt(3) / 2
W, H = 99.0, 50.0

# Profil terena: (x, kota). Levo ravan teren, pa rampa dole u iskop,
# pa dno, pa dve kaskade nazad na kotu. To je doslovno ono sto Axel radi:
# iskop, uredjenje terena i gabionske kaskade na kosini.
PROFILE = [
    (0.0, 30.0), (24.0, 30.0),
    (34.0, 40.0), (56.0, 40.0),
    (56.0, 35.5), (66.0, 35.5),
    (66.0, 31.0), (99.0, 31.0),
]

BOTTOM = 48.0   # dokle se crta masa zemlje
LEFT, RIGHT = 7.0, 92.0


def surface(x):
    """Kota terena na datom x, linearno izmedju tacaka profila."""
    for i in range(len(PROFILE) - 1):
        x0, y0 = PROFILE[i]
        x1, y1 = PROFILE[i + 1]
        if x0 <= x <= x1:
            if x1 == x0:
                return y1
            t = (x - x0) / (x1 - x0)
            return y0 + t * (y1 - y0)
    return PROFILE[-1][1]


def main():
    dots, accents = [], []
    row = 0
    y = 0.0
    while y <= H:
        offset = 0.5 if row % 2 else 0.0
        x = offset
        while x <= W:
            if LEFT <= x <= RIGHT:
                top = surface(x)
                if top <= y <= BOTTOM:
                    # Dva reda uz samu povrsinu su akcenat: tako se linija
                    # terena cita kao crta, a ne kao ivica mrlje.
                    if y - top < 2 * STEP_Y:
                        accents.append((x, y))
                    else:
                        dots.append((x, y))
            x += STEP_X
        y += STEP_Y
        row += 1

    parts = [
        '<svg viewBox="0 0 99 50" xmlns="http://www.w3.org/2000/svg">',
        '<style>circle{r:.3;fill:#D3DAE140}.a{r:.42;fill:#C3CFD8}</style>',
    ]
    for x, y in dots:
        parts.append('<circle cx="%.1f" cy="%.1f"/>' % (x, y))
    for x, y in accents:
        parts.append('<circle class="a" cx="%.1f" cy="%.1f"/>' % (x, y))
    parts.append('</svg>')

    out = os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        'site', 'assets', 'img', 'profil-iskopa.svg')
    with open(out, 'w', encoding='utf-8') as f:
        f.write(''.join(parts))

    print('%s  ->  %d tacaka (%d akcenat), %.1f KB'
          % (os.path.basename(out), len(dots) + len(accents), len(accents),
             os.path.getsize(out) / 1024))


if __name__ == '__main__':
    main()
