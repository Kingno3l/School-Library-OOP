require './nameable'
require './capitalize_decorator'
require './trimmer_decorator'
require 'securerandom'

class Person < Nameable
  attr_accessor :name, :age, :rentals
  attr_reader :id

  def initialize(age, name: 'Unknown', parent_permission: true)
    super()
    @id = rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  def correct_name
    @name
  end

  def add_rental(book, date)
    Rental.new(date, book, self)
  end

  def can_use_services?
    of_age? || @parent_permission
  end

  def to_json(*_args)
    {
      'type' => 'person',
      'name' => @name,
      'age' => @age,
      'id' => @id
    }.to_json
  end

  private

  def of_age?
    age >= 18
  end
end
