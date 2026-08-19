# Website des Musikvereins Hart e.V.

Dies ist die mit Jekyll und Bootstrap entwickelte Website des Musikvereins Hart e.V. aus dem Zollernalbkreis, gehostet auf GitHub Pages.

## GitHub-Actions-Workflows

- `.github/workflows/pages.yml` – baut die Seite bei jedem Push nach `main`, täglich um 05:00 UTC (damit neue/geänderte Konzertmeister-Termine auch ohne Code-Änderung erscheinen) sowie manuell über `workflow_dispatch`, und deployed sie nach GitHub Pages.
- `.github/workflows/release.yml` – erstellt bei jedem Push nach `main` automatisch einen Git-Tag + GitHub-Release nach dem Schema `YYYY.M.VERSION` (z. B. `2026.8.1`).

## Konzertmeister-API (Termine)

Die "Anstehende Termine"-Karte auf der Startseite (`_includes/konzertmeister.html`) wird nicht mehr per iframe eingebunden, sondern bei jedem Build von [Konzertmeister](https://konzertmeister.app) über `script/fetch_termine.rb` in `_data/termine.yml` geschrieben. Übernommen werden nur kommende Termine vom Typ *Performance*, mit Status *aktiv*, die für die öffentliche Website freigegeben wurden (`publicsite: true` in Konzertmeister).

**API-Key erstellen:** In der [Konzertmeister-Web-App](https://web.konzertmeister.app) unter den Organisationseinstellungen einen API-Key für die M2M-Schnittstelle anlegen.

**API-Key sicher hinterlegen:** Niemals im Repository speichern. Stattdessen unter Settings → Secrets and variables → Actions → *New repository secret* → Name `KONZERTMEISTER_API_KEY`, Wert der API-Key.

Ohne gesetzten Key bleibt `_data/termine.yml` unverändert (kein Build-Fehler) – lokales Entwickeln funktioniert also auch ohne Key:

```bash
KONZERTMEISTER_API_KEY="dein-key" bundle exec ruby script/fetch_termine.rb
```