$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fill_pdf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fill_pdf"
  s.version     = FillPdf::VERSION
  s.authors     = ["Armand Niampa", "Hubert Lobit"]
  s.email       = ["armand.niampa@spear.fr", "hubert.lobit@capsens.eu"]
  s.homepage    = "http://www.capsens.eu"
  s.summary     = "A plugin for populate fields in a pdf file and download it."
  s.description = "A plugin for populate fields in a pdf file and download it."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "pdf-forms", "~> 0.6"
  s.add_dependency "combine_pdf", "~> 0.2"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rails"
end
