#!rspec
require 'thor/rake_compat'
require 'bundler'

class Default < Thor
  include Thor::RakeCompat
  Bundler::GemHelper.install_tasks

  desc "spec", "rspec �������s"
  def spec
    exec("rspec spec/*_spec.rb")
  end

  desc "autospec", "�����e�X�g"
  def autospec
    system("start prspecd spec/.prspecd")
    system("start watchr spec/watchr")
  end
end
