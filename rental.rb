class Rental
  attr_accessor :date, :book, :person

  def initialize(date, book, person)
    @date = date
    @book = book
    @person = person

    book.rentals << self
    person.rentals << self
  end

  def to_json(*_args)
    {
      'type' => 'rentals',
      'date' => @date,
      'book' => @book.title, # Assuming title is a unique identifier for a book
      'person' => @person.name # Assuming name is a unique identifier for a person
    }.to_json
  end
end
