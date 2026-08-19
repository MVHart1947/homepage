source "https://rubygems.org"

gem "jekyll", "~> 4.3"

# Bootstrap als Sass-Version einbinden (Quelle: node_modules-freie Ruby-Gem)
gem "bootstrap", "~> 5.3"

# Jekyll benötigt für Sass-Kompilierung Dart-Sass
gem "jekyll-sass-converter", "~> 3.0"

# Lokaler Server unter Ruby 3.x
gem "webrick", "~> 1.8"

# Zeitzonen-korrekte Umrechnung der Konzertmeister-Termine (UTC → Europe/Berlin,
# DST-sicher) in script/fetch_termine.rb
gem "tzinfo", "~> 2.0"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
end

# Windows/JRuby: tzinfo braucht hier zusätzlich die Zonendaten als Gem,
# da diese Betriebssysteme keine eigene Zoneinfo-Datenbank mitbringen.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]
