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
    each do |item|
      result << item if yield(item)
    end
    result
  end

  def my_all?
  end

  def my_any?
  end

  def my_none?
  end

  def my_count
  end
  
  def my_map
  end

  def my_inject
  end
end

#numbers = [1, 2, 3, 4, 5]
#numbers.my_each { |item| puts item }
#numbers.each { |item| puts item }


#numbers = [5, 5, 2, 6, 5]
#numbers.my_each_with_index{ |item, index| puts "#{item}: index#{index}"}
#numbers.each_with_index { |item, index| puts "#{item}: index#{index}"}

numbers = [5, 5, 2, 6, 5]
puts numbers.my_select { |item| item.even? }
puts '--------'
puts numbers.select { |item| item.even?}

