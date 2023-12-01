require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'create_person'
require_relative 'create_rental'
require 'json'

module FileHelper
  def valid_json_file?(file_name)
    File.exist?(file_name) && !File.empty?(file_name)
  end

  def read_json_content(file_name)
    File.read(file_name).strip
  end

  def save_data_to_json(file_name, data)
    puts "Saving data to #{file_name}..."
    File.write(file_name, JSON.generate(data))
    puts "#{file_name} updated successfully."
  rescue StandardError => e
    puts "Error saving data to #{file_name}: #{e.message}"
    e.backtrace.each { |line| puts line }
  end
end

module InputHelper
  def get_user_input(prompt)
    puts prompt
    gets.chomp
  end

  def get_user_input_integer(prompt)
    get_user_input(prompt).to_i
  end
end

class App
  include FileHelper
  include InputHelper

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
    type = get_user_input_integer('Do you want to create a student (1) or a teacher (2)? [Input the number]:')
    name = get_user_input('Enter the person\'s name:')
    age = get_user_input_integer('Enter the person\'s age:')

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
    save_people_to_json
  end

  def create_book
    title = get_user_input('Enter the book\'s title:')
    author = get_user_input('Enter the book\'s author:')

    book = Book.new(title, author)
    return unless book

    @books << book
    puts "Book created with title: #{book.title}, author: #{book.author}"
    save_books_to_json
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
    save_rentals_to_json
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
