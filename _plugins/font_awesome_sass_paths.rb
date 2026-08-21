# Registriert den Sass-Quellordner der "font-awesome-sass"-Gem als
# zusätzlichen Sass-Load-Path (analog zu _plugins/bootstrap_sass_paths.rb)
# und kopiert deren Font-Dateien nach jedem Build in den Output. So muss
# Font Awesome nicht mehr manuell im Repository vendort werden.
Jekyll::Hooks.register :site, :after_init do |site|
  spec = Gem::Specification.find_by_name("font-awesome-sass")
  stylesheets_path = File.join(spec.gem_dir, "assets", "stylesheets")

  site.config["sass"] ||= {}
  site.config["sass"]["load_paths"] ||= []
  site.config["sass"]["load_paths"] << stylesheets_path
end

Jekyll::Hooks.register :site, :post_write do |site|
  spec = Gem::Specification.find_by_name("font-awesome-sass")
  fonts_source = File.join(spec.gem_dir, "assets", "fonts", "font-awesome")
  fonts_dest = File.join(site.dest, "assets", "fonts")

  FileUtils.mkdir_p(fonts_dest)
  Dir.glob(File.join(fonts_source, "*")).each do |font_file|
    FileUtils.cp(font_file, fonts_dest)
  end
end
