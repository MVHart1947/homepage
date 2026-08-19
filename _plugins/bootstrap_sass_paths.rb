# Registriert den Sass-Quellordner der "bootstrap"-Gem als zusätzlichen
# Sass-Load-Path, damit `@import "bootstrap"` in assets/css/main.scss
# funktioniert, ohne Bootstrap manuell im Repository zu vendoren.
#
# Hinweis: Die "bootstrap"-Gem (twbs, ab v5) stellt keine eigene Ruby-API
# wie `Bootstrap.load_path` mehr bereit – der Pfad wird daher direkt über
# Gem::Specification ermittelt.
Jekyll::Hooks.register :site, :after_init do |site|
  spec = Gem::Specification.find_by_name("bootstrap")
  stylesheets_path = File.join(spec.gem_dir, "assets", "stylesheets")

  site.config["sass"] ||= {}
  site.config["sass"]["load_paths"] ||= []
  site.config["sass"]["load_paths"] << stylesheets_path
end
