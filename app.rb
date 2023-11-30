require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'create_person'
require_relative 'create_rental'

class App
  attr_accessor :books, :people, :rentals

  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  include PersonCreator
  include RentalHelper

  def list_all_books
    puts 'List of all books:'
    @books.each { |book| puts "Title: \"#{book.title}\", Author: #{book.author}" }
  end

  def list_all_people
    puts 'List of all people:'
    @people.each { |person| puts "[#{person.class}]: Name: #{person.name}, Age: #{person.age}, ID: #{person.id}" }
  end

  def create_person
    puts 'Do you want to create a student (1) or a teacher (2)? [Input the number]:'
    type = gets.chomp.to_i

    puts 'Enter the person\'s name:'
    name = gets.chomp

    puts 'Enter the person\'s age:'
    age = gets.chomp.to_i

    if type == 1
      person = PersonCreator.create_student(name, age)
    elsif type == 2
      person = PersonCreator.create_teacher(name, age)
    else
      puts 'Invalid person type. Please try again.'
    end

    @people << person
    puts "#{person.class} #{person.name} created with ID: #{person.id}"
  end

  def create_book
    puts 'Enter the book\'s title:'
    title = gets.chomp

    puts 'Enter the book\'s author:'
    author = gets.chomp

    book = Book.new(title, author)
    @books << book
    puts "Book created with title: #{book.title}, author: #{book.author}"
  end

  def create_rental
    selected_person = select_person
    return puts 'Invalid person selection.' if selected_person.nil?

    selected_book = select_book
    return puts 'Currently, there is no book.' if selected_book.nil?

    date = rental_date
    rental = create_and_store_rental(selected_book, selected_person, date)

    puts "Rental created for book: #{selected_book.title}, person: #{selected_person.name}, date: #{rental.date}"
  end

  private

  def select_person
    RentalHelper.list_people_for_selection(@people)
    person_choice = gets.chomp.to_i
    @people[person_choice]
  end

  def select_book
    RentalHelper.list_books_for_selection(@books)
    book_choice = gets.chomp.to_i
    @books[book_choice]
  end

  def rental_date
    puts 'Enter the rental date (YYYY-MM-DD):'
    gets.chomp
  end

  def create_and_store_rental(book, person, date)
    rental = Rental.new(date, book, person)
    @rentals << rental
    rental
  end

  def list_rentals_for_person
    puts 'Enter the person\'s ID:'
    person_id = gets.chomp.to_i

    person = @people.find { |p| p.id == person_id }

    if person.nil?
      puts 'Person not found'
      return
    end

    puts "Rentals for person #{person.name}:"
    rentals = @rentals.select { |r| r.person == person }
    rentals.each { |rental| puts "Book: #{rental.book.title}, Date: #{rental.date}" }
  end

  def quit
    puts 'Thank you for using School Library. Goodbye!'
    exit
  end

  # save to file
  def save_data_to_json(file_name, data)
    File.write(file_name, JSON.generate(data))
    puts "#{file_name} updated successfully."
  end

  def save_books_to_json
    save_data_to_json('books.json', @books)
  end

  def save_people_to_json
    save_data_to_json('people.json', @people)
  end

  def save_rentals_to_json
    save_data_to_json('rentals.json', @rentals)
  end

  # Loading data from JSON files
  def load_data_from_json(file_name)
    return [] unless File.exist?(file_name)

    JSON.parse(File.read(file_name)).map do |record|
      # You'll need to customize this based on your object structure
      # Example: Book.new(record['title'], record['author'])
      # Example: Person.new(record['name'], record['age'])
      # Example: Rental.new(record['date'], record['book'], record['person'])
    end
  end

  def load_books_from_json
    @books = load_data_from_json('books.json')
  end

  def load_people_from_json
    @people = load_data_from_json('people.json')
  end

  def load_rentals_from_json
    @rentals = load_data_from_json('rentals.json')
  end
end
