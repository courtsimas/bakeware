# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bakeware/version"

Gem::Specification.new do |s|
  s.name     = 'bakeware'
  s.version  = Bakeware::VERSION
  s.date     = Date.today.strftime('%Y-%m-%d')
  s.authors  = ["courtsimas"]
  s.email    = 'courtsimas@gmail.com'
  s.homepage = 'http://github.com/courtsimas/bakeware'

  s.summary     = "Generate a Rails app using Oven Bits' favorite flavors and ingredients."
  s.description = <<-DOLLADOLLABILLSYALL
Bakeware is a base Rails project that you can upgrade. It comes in two flavors - lean or meaty. 
We use it at Oven Bits for most of our apps. YMMV, but we get decent mileage out of it ;)
  DOLLADOLLABILLSYALL

  s.files = `git ls-files`.split("\n").
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency 'rails', '>= 3.2.8'
  s.add_dependency 'bundler', '>= 1.1'
  s.add_dependency 'hub', '~> 1.10.2'

  s.add_development_dependency 'cucumber', '~> 1.1.9'
  s.add_development_dependency 'aruba', '~> 0.4.11'
end
