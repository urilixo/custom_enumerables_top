require 'pry-byebug'
module Enumerable
  def my_each
    for i in self do
      yield i
    end
  end

  def my_each_with_index
    for i in 0..self.length do
      yield self[i], i
    end
  end

  def my_select
    result = []
    my_each do |item|
      result << item if yield(item)
    end
    result
  end

  def my_all?(type = nil)
    result = []
    if block_given?
      my_each { |item| result << true unless (type =~ item).nil? } if type.instance_of?(Regexp)

      my_each { |item| result << yield(item) if yield(item) } if type.instance_of?(NilClass)
    else
      my_each { |item| result << true if type === item }
    end
    result.length == length
  end

  def my_any?(type = nil)
    result = []
    if block_given?
      my_each { |item| result << true unless (type =~ item).nil? } if type.instance_of?(Regexp)

      my_each { |item| result << yield(item) if yield(item) } if type.instance_of?(NilClass)
    else
      my_each { |item| result << true if type === item }
    end
    result.length.positive?
  end

  def my_none?(type = nil)
    result = []
    if block_given?
      my_each { |item| result << true unless (type =~ item).nil? } if type.instance_of?(Regexp)

      my_each { |item| result << yield(item) if yield(item) } if type.instance_of?(NilClass)
    else
      my_each { |item| result << true if (type === item && !item.nil?) || item == true}
    end
    result.length.zero?
  end

  def my_count(value = nil)
    result = []
    if block_given?
      my_each { |item| result << true if yield(item) }
    elsif !value.nil?
      my_each { |item| result << true if item == value }
    else
      my_each { result << true }
    end
    result.length
  end

  def my_map(proc = nil)
    result = []
    if proc.nil?
      my_each { |item| result << yield(item) } if block_given?
    else
      my_each { |item| result << proc.call(item) }
    end
    result
  end

  def my_inject(*args)
    @accum = 0
    unless args.empty?
      args.my_each do |arg|
        @operator = arg if arg.instance_of?(Symbol)
        @accum = arg if Numeric === arg
      end
    end
    if block_given?
      @accum = self[0] if instance_of?(Array)
      my_each do |item|
        @accum = yield(@accum, item)
      end
    else
      my_each do |b|
        @accum = @accum.public_send @operator, b
      end
    end
    @accum
  end
end

def multiply_els(array)
  p array.my_inject(1, :*)
end

multiply_els([2,4,5])
# numbers = [1, 2, 3, 4, 5]
# numbers.my_each { |item| puts item }
# numbers.each { |item| puts item }

# numbers = [5, 5, 2, 6, 5]
# numbers.my_each_with_index{ |item, index| puts "#{item}: index#{index}"}
# numbers.each_with_index { |item, index| puts "#{item}: index#{index}"} 

# numbers = [5, 5, 2, 6, 5]
# puts numbers.my_select { |item| item.even? }
# puts '--------'
# puts numbers.select { |item| item.even?} 

# animals = ['dog', 'cat', 'badger']
# puts animals.my_all? { |animal| animal.length >=3 }
# puts animals.my_all?(String)
# puts '--------'
# puts animals.all? { |animal| animal.length >=3 }
# puts animals.all?(String)

# animals = ['dog', 'cat', 'badger']
# puts animals.my_any? { |animal| animal.length >6 }
# puts animals.my_any?(String)
# puts '--------'
# puts animals.any? { |animal| animal.length >6 }
# puts animals.any?(String)

# animals = ['dog', 'cat', 'badger']
# puts animals.my_none? { |animal| animal == 'tiger' }
# puts animals.my_none? { |animal| animal == 'dog' }
# puts animals.my_none?(String)
# puts '--------'
# puts animals.none? { |animal| animal == 'tiger' }
# puts animals.none? { |animal| animal == 'dog' }
# puts animals.none?(String)

# puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# puts %w[ant bear cat].my_all?(/t/)                        #=> false
# puts [1, 2i, 3.14].my_all?(Numeric)                       #=> true
# puts [nil, true, 99].my_all?                              #=> false
# puts [].my_all?                                           #=> true

# puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# puts %w[ant bear cat].my_any?(/d/)                        #=> false
# puts [nil, true, 99].my_any?(Integer)                     #=> true
# puts [nil, true, 99].my_any?                              #=> true
# puts [].my_any?                                           #=> false

# puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# puts %w{ant bear cat}.my_none?(/d/)                        #=> true
# puts [1, 3.14, 42].my_none?(Float)                         #=> false
# puts [].my_none?                                           #=> true

# puts [nil].my_none?                                        #=> true
# puts [nil, false].my_none?                                 #=> true
# puts [nil, false, true].my_none?                           #=> false

# ary = [1, 2, 4, 2]
# puts ary.my_count               #=> 4
# puts ary.my_count(2)            #=> 2
# puts ary.my_count{ |x| x%2==0 } #=> 3

# p (1..4).my_map { |i| i*i }      #=> [1, 4, 9, 16]
# p (1..4).my_map { "cat"  }   #=> ["cat", "cat", "cat", "cat"]

# Sum some numbers
# p (5..10).my_inject(:+)                             #=> 45
# Same using a block and inject
# p (5..10).my_inject { |sum, n| sum + n }            #=> 45
# Multiply some numbers
# p (5..10).my_inject(1, :*)                          #=> 151200
# Same using a block
# p (5..10).my_inject(1) { |product, n| product * n } #=> 151200
# find the longest word
# longest = %w{ cat sheep bear }.my_inject do |memo, word|
#   #memo.length > word.length ? memo : word
#end
#p longest                                        #=> "sheep"
my_map_proc = proc { |i| i*i }
p (1..4).my_map(my_map_proc)