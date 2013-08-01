module Chores
  class Chore
    attr_accessor :on_success, :on_failure, :on_stderr
    attr_accessor :command, :stdin, :stdout, :stderr
    attr_accessor :cost, :thread, :result
    attr_accessor :deps, :name

    def initialize(opts)
      [:on_success, :on_failure, :on_stderr].each do |cb|
        self.send :"#{cb}=", opts.fetch(cb).dup
      end

      self.name = opts[:name] || nil
      self.deps = opts[:deps] || []

      self.command = opts.fetch(:command).dup
      self.command = [self.command] unless self.command.is_a? Array
      self.cost    = opts[:cost] || nil
      self.stdin   = opts[:stdin] || nil
      self.stdout  = nil
      self.stderr  = Queue.new
      self.result  = :working
    end

    def satisfied?(completed)
      self.deps.empty? || self.deps.all?{|d| completed.include?(d)}
    end

    def run!
      self.thread = Thread.new do
        Open3.popen3(* self.command) do |i, o, e, t|
          i.write(self.stdin); i.close

          e.each_line do |line|
            self.stderr << line
          end
          e.close

          self.stdout = o.read
          o.close

          exit_status = t.value

          if exit_status.success?
            self.result = :success
          else
            self.result = :failure
          end
        end
      end
    end

    def complete?
      self.result == :success || self.result == :failure
    end

    def handle_completion
      if self.result == :success
        self.on_success.call
      elsif self.result == :failure
        self.on_failure.call
      else
        raise "This should not happen"
      end
    end

    def failed?
      self.result == :failure
    end
  end
end
