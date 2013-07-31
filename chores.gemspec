require File.expand_path('../lib/chores/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = "chores"
  s.version         = Chores::VERSION
  s.date            = Time.now.utc.strftime('%Y-%m-%d')
  s.summary         = "Put those child-processes to WORK"
  s.description     = "Manage multiple child-processes via green threads"
  s.authors         = ["Eric Mueller"]
  s.email           = "emueller@emcien.com"
  s.files           = [
    "README.md",
    "lib/chores.rb",
    "lib/chores/chore.rb",
    "lib/chores/boss.rb",
    "lib/chores/version.rb",
  ]
  s.homepage        = "http://github.com/emcien/chores"
  s.require_paths   = ['lib']
  s.bindir          = 'scripts'

  s.required_rubygems_version = Gem::Requirement.new(">= 1")
end
