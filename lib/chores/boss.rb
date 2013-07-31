module Chores
  class Boss
    attr_accessor :max_children, :chores, :in_progress

    def initialize(number_of_children)
      self.max_children = number_of_children
      self.chores = []
      self.in_progress = []
    end

    def add_chore(opts)
      self.chores << Chores::Chore.new(opts)
    end

    def assign_next_chore
      return unless self.chores.any?
      return if self.in_progress.length >= self.max_children

      next_chore = self.chores.shift
      next_chore.run!

      self.in_progress << next_chore
    end

    def free_children?
      self.in_progress.length < self.max_children
    end

    def done?
      self.chores.empty? && self.in_progress.empty?
    end

    def handle_complaints
      self.in_progress.each do |chore|
        until chore.stderr.empty?
          chore.on_stderr.call(chore.stderr.shift)
        end
      end
    end

    def check_children
      remaining = []
      self.in_progress.each do |chore|
        if chore.complete?
          chore.handle_completion
        else
          remaining << chore
        end
      end

      self.in_progress = remaining
    end

    def run!
      # get the chores into longest job first - this is to minimize net runtime
      self.chores = self.chores.sort_by{|c| - c.cost.to_f}

      # queue up the first set of chores
      while self.chores.any? and self.free_children?
        self.assign_next_chore
      end

      # watch the children, and assign new chores if any get free
      until self.done?
        sleep 0.25

        self.handle_complaints
        self.check_children

        while self.free_children? and self.chores.any?
          self.assign_next_chore
        end
      end
    end
  end
end
