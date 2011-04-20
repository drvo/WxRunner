#!rspec
require "wx_runner"
require 'thread'

WxRunner.run_thread
# ���C����ʂ͕\������Ă��Ȃ��ƁA���b�Z�[�W���[�v���I�����Ă��܂��B
main_wnd = WxRunner.on_wx_thread { Wx::TextCtrl.show }

describe "WxRunner show textctrl" do
  it "TextCtrl show" do
    r = WxRunner.on_wx_thread { Wx::TextCtrl.show }
    r.class.should == Wx::TextCtrl
    WxRunner.on_wx_thread { r.parent.close }
  end

  it "Checkbox show" do
    r = WxRunner.on_wx_thread { Wx::CheckBox.show }
    r.class.should == Wx::CheckBox
    WxRunner.on_wx_thread { r.parent.close }
  end
end
