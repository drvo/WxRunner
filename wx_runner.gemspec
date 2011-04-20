# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wx_runner/version"

Gem::Specification.new do |s|
  s.name        = "wx_runner"
  s.version     = WxRunner::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["drvo"]
  s.email       = ["drvo.gm@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{wx ruby プログラム実行補助} # wx ruby   run assistance program
  s.description = %q{wx ruby プログラムで、別スレッドでのメインループ実行サポート。ウインドウクラスにrun, show を追加。} # wx ruby   program, support for running the main loop of another thread. Window class run, show added.

  s.rubyforge_project = "wx_runner"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
