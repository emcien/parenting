require File.expand_path('../lib/parenting/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = "parenting"
  s.version         = Parenting::VERSION
  s.date            = Time.now.utc.strftime('%Y-%m-%d')
  s.summary         = "Put those child-processes to WORK"
  s.description     = "Manage multiple child-processes via green threads"
  s.authors         = ["Emcien"]
  s.email           = "engineering@emcien.com"
  s.files           = [
    "README.md",
    "lib/parenting.rb",
    "lib/parenting/chore.rb",
    "lib/parenting/boss.rb",
    "lib/parenting/version.rb",
  ]
  s.homepage        = "http://github.com/emcien/parenting"
  s.require_paths   = ['lib']
  s.bindir          = 'scripts'

  s.required_rubygems_version = Gem::Requirement.new(">= 1")
end
