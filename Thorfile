#!rspec
require 'thor/rake_compat'
require 'bundler'

class Default < Thor
  include Thor::RakeCompat
  Bundler::GemHelper.install_tasks

  desc "spec", "rspec 処理実行"
  def spec
    exec("rspec spec/*_spec.rb")
  end

  desc "autospec", "自動テスト"
  def autospec
    system("start prspecd spec/.prspecd")
    system("start watchr spec/watchr")
  end
end
