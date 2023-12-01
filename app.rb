require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'create_person'
require_relative 'create_rental'
require 'json'

class App
  attr_accessor :books, :people, :rentals

  def initialize
    @books = []
    @people = []
    @rentals = []

    load_books_from_json
    load_people_from_json
    load_rentals_from_json
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

    return unless person

    @people << person
    puts "#{person.class} #{person.name} created with ID: #{person.id}"
    save_people_to_json # Save people data after successful creation
  end

  def create_book
    puts 'Enter the book\'s title:'
    title = gets.chomp

    puts 'Enter the book\'s author:'
    author = gets.chomp

    book = Book.new(title, author)
    return unless book

    @books << book
    puts "Book created with title: #{book.title}, author: #{book.author}"
    save_books_to_json # Save books data after successful creation
  end

  def create_rental
    selected_person = select_person
    return puts 'Invalid person selection.' if selected_person.nil?

    selected_book = select_book
    return puts 'Currently, there is no book.' if selected_book.nil?

    date = rental_date
    rental = create_and_store_rental(selected_book, selected_person, date)

    return unless rental

    @rentals << rental
    puts "Rental created for book: #{selected_book.title}, person: #{selected_person.name}, date: #{rental.date}"
    save_rentals_to_json # Save rentals data after successful creation
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
    puts "Saving data to #{file_name}..."
    File.write(file_name, JSON.generate(data))
    puts "#{file_name} updated successfully."
  rescue StandardError => e
    puts "Error saving data to #{file_name}: #{e.message}"
    e.backtrace.each { |line| puts line } # This will print the backtrace for better debugging
  end

  def save_books_to_json
    puts 'Saving books...'
    save_data_to_json('books.json', @books)
  end

  def save_people_to_json
    puts 'Saving people...'
    save_data_to_json('people.json', @people)
  end

  def save_rentals_to_json
    puts 'Saving rentals...'
    save_data_to_json('rentals.json', @rentals)
  end

  # Loading data from JSON files
  def load_data_from_json(file_name)
    return [] unless File.exist?(file_name) && !File.empty?(file_name)

    json_content = File.read(file_name)
    return [] if json_content.strip.empty? # Handles empty JSON content

    JSON.parse(File.read(file_name)).map do |record|
      case record['type']
      when 'book'
        Book.new(record['title'], record['author'])
      when 'person'
        Person.new(record['age'], name: record['name'])
      when 'rental'
        book = find_book_by_title(record['book_title']) # Implement find_book_by_title logic
        person = find_person_by_name(record['person_name']) # Implement find_person_by_name logic
        Rental.new(record['date'], book, person)
      else
        nil # Handle other types or errors as needed
      end
    end.compact # Remove any nil values from the resulting array
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
