# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "xml2xls/version"

Gem::Specification.new do |s|
  s.name        = "xml2xls"
  s.version     = Xml2xls::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Kostenchuk"]
  s.email       = ["kmi9.other@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Transforms specific xml to xls}
  s.description = %q{Transforms specific xml to excel-xml file using xsl templates}

  s.rubyforge_project = "xml2xls"
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'spreadsheet'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", 'lib']
end
