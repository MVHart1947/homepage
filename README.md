# Musikverein Hart e.V. – Website

[![Build & Deploy nach GitHub Pages](https://github.com/MVHart1947/homepage/actions/workflows/pages.yml/badge.svg)](https://github.com/MVHart1947/homepage/actions/workflows/pages.yml)

Quellcode der offiziellen Website des [Musikverein Hart e.V.](https://www.musikverein-hart.de) – Blasmusikverein aus dem Zollernalbkreis, mit Terminen, Mitgliedern, Vorstandschaft und Impressum.

## Tech-Stack

- [Jekyll](https://jekyllrb.com) 4.3 (Ruby, statischer Seitengenerator)
- [Bootstrap](https://getbootstrap.com) 5.3 als Ruby-Gem eingebunden (siehe [`_plugins/bootstrap_sass_paths.rb`](_plugins/bootstrap_sass_paths.rb)), kein CDN-Aufruf zu Drittanbietern
- [Font Awesome](https://fontawesome.com) manuell unter `assets/fontawesome/` vendort (kein Gem, kein CDN)
- Bootstraps JS-Bundle (`assets/js/bootstrap.bundle.min.js`) nur für die Collapse-Funktion des mobilen Navigations-Togglers; [Salvattore](https://github.com/rnmp/salvattore) (`assets/js/salvattore.js`) für das Masonry-Grid auf `mitglieder.html` und `datenschutz.html` – sonst kein eigenes JavaScript

### Farben

| Rolle    | Hex       | Verwendung                     |
|----------|-----------|----------------------------------|
| Primär   | `#0255a3` | Buttons, Links, Akzente          |
| Sekundär | `#eb1c24` | Hervorhebungen                   |
| Tertiär  | `#919396` | Trennlinien, dezente Flächen     |

Definiert in `_sass/vars.scss` – dort auch die Bootstrap-Farb-Map (`$primary`/`$secondary`/`$tertiary`), damit z.&nbsp;B. `btn-primary` automatisch in der Vereinsfarbe erscheint.

## Lokale Entwicklung

Voraussetzung: Ruby >= 3.1 und Bundler.

```bash
bundle install             # Gems installieren
bundle exec jekyll serve   # Dev-Server mit Live-Rebuild unter http://127.0.0.1:4000
bundle exec jekyll build   # Statische Seite nach _site/ bauen
```

Es gibt keine Tests oder Linter in diesem Repo.

## Struktur

- `index.html`, `historie.html`, `jugend.html`, `mitglieder.html`, `vorstandschaft.html`, `partnerkapelle.html`, `kontakt.html`, `downloads.html`, `impressum.html`, `datenschutz.html` – die Seiten der Website
- `_layouts/`, `_includes/` – gemeinsames Seitengerüst (Navigation, Footer, Register-/Termine-Karten)
- `_data/` – listenartiger Inhalt (Mitglieder, Register, Vorstandschaft, Termine, Navigation, Rechtliches), wird per `{% for %}`-Schleife eingebunden
- `_sass/`, `assets/css/main.scss` – Styling (Bootstrap + eigene Anpassungen)
- `_config.yml` – Site-Einstellungen inkl. Vereinskontakt (`contact.*`)
- `script/fetch_termine.rb` – holt die Konzerttermine von der Konzertmeister-API (siehe unten)

Mehr Architektur-Details (inkl. einiger nicht offensichtlicher Stolperfallen) stehen in [CLAUDE.md](CLAUDE.md).

## Konzertmeister-API (Termine)

Die "Anstehende Termine"-Karte auf der Startseite (`_includes/termine.html`) wird nicht manuell gepflegt, sondern bei jedem Build von [Konzertmeister](https://konzertmeister.app) über `script/fetch_termine.rb` in `_data/termine.yml` geschrieben. Übernommen werden nur kommende Termine vom Typ *Performance*, mit Status *aktiv*, die für die öffentliche Website freigegeben wurden (`publicsite: true` in Konzertmeister).

**API-Key erstellen:** In der [Konzertmeister-Web-App](https://web.konzertmeister.app) unter den Organisationseinstellungen einen API-Key für die M2M-Schnittstelle anlegen.

**API-Key sicher hinterlegen:** Ein Konzertmeister-API-Key darf **niemals** im Repository landen (GitHub Pages ist immer öffentlich erreichbar, egal ob das Repo privat oder öffentlich ist). Stattdessen als **verschlüsseltes Repository-Secret** hinterlegen:

Settings → Secrets and variables → Actions → *New repository secret* → Name `KONZERTMEISTER_API_KEY`, Wert der API-Key.

Der Workflow ([`.github/workflows/pages.yml`](.github/workflows/pages.yml)) reicht das Secret nur während des Build-Jobs als Umgebungsvariable an das Fetch-Script durch – der Key landet nie im ausgelieferten `_site`-Verzeichnis und ist für Website-Besucher:innen nicht einsehbar.

**Lokal mit echten Daten arbeiten** (optional): Key nur für den einen Aufruf als Umgebungsvariable setzen, nicht dauerhaft exportieren:

```bash
KONZERTMEISTER_API_KEY="dein-key" bundle exec ruby script/fetch_termine.rb
```

Ohne gesetzten Key bleibt die zuletzt im Repo vorhandene `_data/termine.yml` unverändert – lokales Entwickeln funktioniert also auch ohne Key.

## Deployment

Die Website liegt auf [GitHub Pages](https://pages.github.com) unter der eigenen Domain `https://www.musikverein-hart.de` (als Custom Domain in den Repository-Settings hinterlegt).

Workflow: Alle Änderungen laufen über den `develop`-Branch. Sobald `develop` nach `main` gemerged/gepusht wird, laufen automatisch zwei GitHub-Actions-Workflows:

- [`.github/workflows/pages.yml`](.github/workflows/pages.yml) baut die Seite (`bundle exec jekyll build`) und deployed sie auf GitHub Pages. Er läuft zusätzlich täglich per `schedule`, damit neue/geänderte Konzertmeister-Termine auch ohne Code-Änderung erscheinen.
- [`.github/workflows/release.yml`](.github/workflows/release.yml) erstellt automatisch ein neues [Release](https://github.com/MVHart1947/homepage/releases) nach dem Schema `YYYY.MM.VERSION` (z.&nbsp;B. `2026.08.1`), mit Release-Notes aus dem Commit-Log seit dem letzten Tag.

**Einmalig im Repository eingerichtet:** Settings → Pages → *Build and deployment* → Source auf „GitHub Actions" gestellt.
