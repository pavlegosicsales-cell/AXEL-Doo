# context/

Sve što agent mora da zna o projektu, a ne može da izvuče iz koda.

Šta ide ovde:

- `PROJECT_CONTEXT.json` — puni brifing profil (projekat, stack, odluke,
  ograničenja, šta je urađeno, šta je sledeće). Ovo se čita na početku sesije.
- Klijentski inputi: brif, ciljna grupa, ponuda, cene, tekstovi, kontakt podaci
- Odluke koje su donete i razlozi zašto

Konvertuj relativne datume u apsolutne. Ako se odluka promeni, ažuriraj fajl —
ne dodaj drugi.
