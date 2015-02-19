$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fill_pdf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fill_pdf"
  s.version     = FillPdf::VERSION
  s.authors     = ["Armand Niampa"]
  s.email       = ["armand.niampa@spear.fr"]
  s.homepage    = "http://www.armandniampa.fr"
  s.summary     = "A plugin for populate pdf fields and download it"
  s.description = "A plugin for populate pdf fields and download it"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "pdf-forms"
end
