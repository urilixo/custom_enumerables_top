module Enumerable
  def my_each
    for i in self do
      yield i
    end
  end
end

numbers = [1, 2, 3, 4, 5]
numbers.my_each { |item| puts item }
numbers.each { |item| puts item }
