# Axel DOO

Sajt za građevinsku firmu **Axel DOO** iz Niša — zemljani radovi, rušenje
objekata i priprema terena. Projekat radi po **WAT framework**-u (Workflows,
Agents, Tools), detalji u [WAT.md](WAT.md).

## Status

Skelet postavljen. Materijal od klijenta je tu (logo, 19 gradilišnih
fotografija, 4 video snimka, profil ponude u `context/service_details.md`).
Vizuelni pravac i sadržaj čekaju dogovor.

## Struktura

```
.tmp/           # privremeni fajlovi, potrošni (gitignored)
assets/         # izvorne fotografije i video sa gradilišta
brand_assets/   # logo i zvanični brend materijal
context/        # brif, profil ponude, klijentski input
research/       # teardown-ovi referentnih sajtova
site/           # sajt (HTML/CSS/JS)
skills/         # eksterni skillovi (vendored, gitignored)
tools/          # Python skripte za deterministično izvršavanje
workflows/      # markdown SOP-ovi
```

## Lokalni server

```
cd AXEL/site
python -m http.server 5501 --bind 127.0.0.1
```
→ <http://127.0.0.1:5501>

## Napomene

- `skills/ui-ux-pro-max-skill/` je zaseban klon sa
  <https://github.com/nextlevelbuilder/ui-ux-pro-max-skill> i ne prati se u
  ovom repou. Pretraga:
  `python skills/ui-ux-pro-max-skill/src/ui-ux-pro-max/scripts/search.py "<upit>" --domain product|style|color|typography|landing|ux|gsap`
- Ključevi idu isključivo u `.env`, nigde drugde.
- Podaci koji nisu potvrđeni od klijenta ne idu na sajt kao tvrdnja. Otvorena
  pitanja su na dnu `context/service_details.md`.
