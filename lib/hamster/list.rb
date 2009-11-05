module Hamster

  class List

    include Enumerable

    def initialize(head = nil, tail = self)
      @head = head
      @tail = tail
    end

    # Returns <tt>true</tt> if the list contains no items.
    def empty?
      @tail.equal?(self)
    end

    # Returns the number of items in the list.
    def size
      if empty?
        0
      else
        @tail.size + 1
      end
    end

    # Returns the first item.
    def car
      @head
    end

    # Returns a copy of <tt>self</tt> without the first item.
    def cdr
      @tail
    end

    # Returns a copy of <tt>self</tt> with it as the head.
    def cons(item)
      self.class.new(item, self)
    end

    # Calls <tt>block</tt> once for each item in the list, passing the item as the only parameter.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      unless empty?
        yield(@head)
        @tail.each { |item| yield(item) }
      end
      self
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      blammo!
    end
    alias :== :eql?

    # Returns <tt>self</tt>
    def dup
      self
    end
    alias :clone :dup

    def caar(count = 1)
      list = self
      count.times { list = list.car }
      list.car
    end

    def cadr(count = 1)
      list = self
      count.times { list = list.cdr }
      list.car
    end
    
    def map
      if empty?
        self
      else
        @tail.map { |item| yield item }.cons(yield(@head))
      end
    end
    
    def reduce(memo)
      if empty?
        memo
      else
        @tail.reduce(yield(memo, @head)) do |memo, item|
          yield(memo, item)
        end
      end
    end

    private

    def method_missing(name, *args, &block)
      case name.to_s
      when /^ca(a{2,})r$/ then caar($1.length)
      when /^ca(d{2,})r$/ then cadr($1.length)
      else super
      end
    end

  end

end
