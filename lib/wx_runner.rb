require 'wx'
require 'thread'

module WxRunner extend self
  # &block - ����������������ɌĂяo�����B App �N���X�C���X�^���X���n����܂��B
  def run(&block)
    # app �N���X��ێ����Ă����Ȃ��ƁAsegfalt
    # ./wxutils/app.rb:11: [BUG] rb_gc_mark(): unknown data type 0x0(0x66c200fc) non object
    @app = App.new
    @app.at_exit = @at_exit
    if @init_wait_queue
      @app.block = Proc.new { block.call if block; @init_wait_queue.push(1) }
    else
      @app.block = block
    end
    @app.main_loop
  end

  # �ʃX���b�h�� wx ���b�Z�[�W���[�v�����s
  def run_thread(&block)
    @init_wait_queue = SizedQueue.new(1)
    Thread.new do
      begin
        self.run(&block)
      rescue Exception
        puts $!.message
        puts $!.backtrace
      end
    end
    @init_wait_queue.pop
  end
  
  # wx ���b�Z�[�W�X���b�h�ŏ��������s����
  def on_wx_thread(&block)
    @app.on_wx_thread_proc_queue << {:proc => block.to_proc, :queue => q = Queue.new}
    q.pop
  end

  # wx ���b�Z�[�W�X���b�h�ŏ��������s����
  # �񓯊����s
  def on_wx_thread_async(&block)
    @app.on_wx_thread_proc_queue << {:proc => block.to_proc, :queue => q = Queue.new}
  end

	class App < ::Wx::App 
		attr_accessor :block, :main_wnd_class, :at_exit, :on_wx_thread_proc_queue
		def initialize(*arg)
			super
			@on_wx_thread_proc_queue = Queue.new
		end
	  def on_init
	    # wxRuby �ŃX���b�h���g�p���邽��
      t = Wx::Timer.new(self, 55)
      evt_timer(55) do
        sleep(0.05)
        if not @on_wx_thread_proc_queue.empty?
          i = @on_wx_thread_proc_queue.pop
          begin
            i[:queue].push i[:proc].call
          rescue Exception
            i[:queue].push $!
          end
        end
      end
      t.start(100)

      if @main_wnd_class
        set_top_window( @main_wnd_class.new(nil) )
        get_top_window.show
      end
	    if @block
	    	@block.call(self)
	    end
	    return true
	  end
	end
end

class Wx::Window
	def self.run(*arg, &block)
    WxRunner::App.run { self.show(*arg, &block) }
  end

  def self.show(*arg, &block)
    top, me = self.new_top_window(nil, *arg)
    top.show
    block.call(me) if block
    return me
  end

  # �ŏ�ʔz�u�\�ȃE�C���h�E�𐶐��B
  # �Q�l��Ԃ��B
  # [ �g�b�v���x���E�C���h�E, ��������self�N���X�̃C���X�^���X]
  def self.new_top_window(parent=nil, *arg)
    if self.ancestors.include? Wx::TopLevelWindow
      me = self.new(parent, *arg)
      return me,me
    else
      frame = Wx::Frame.new(parent, :title => "class : #{self}")
      me = self.new(frame, *arg)
      return frame, me
    end
  end
end
