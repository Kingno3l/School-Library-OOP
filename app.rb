require_relative 'person'
require_relative 'book'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'

class App
  attr_reader :people, :books, :rentals

  def initialize
    @people = []
    @books = []
    @rentals = []
  end

  # Method to list all books
  def list_all_books
    # Display all books
    @books.each do |book|
      puts "#{book.title} by #{book.author}"
    end
  end

  # Method to list all people
  def list_all_people
    puts "Students:"
    @people.each do |person|
      if person.is_a?(Student)
        puts "Name: #{person.name} ID: #{person.id} Age: #{person.age}"
      end
    end

    puts "\nTeachers:"
    @people.each do |person|
      if person.is_a?(Teacher)
        puts "Name: #{person.name} ID: #{person.id} Age: #{person.age}"
      end
    end
  end


  # Method to create a person (teacher or student)
  def create_person(type, id, age, classroom = nil, name, parent_permission: true, specialization: nil)
  if type == 'teacher'
    person = Teacher.new(age, name, specialization)
  elsif type == 'student'
    # id ||= rand(1..100) # Auto-generate an ID if not provided
    person = Student.new(age, name, parent_permission)
  else
    puts 'Invalid person type!'
    return
  end
  @people << person
  puts "#{type.capitalize} #{person.name} created successfully!"
  end

  # Method to create a book
  def create_book(title, author)
    book = Book.new(title, author)
    @books << book
    puts "Book '#{book.title}' by #{book.author} created successfully!"
  end

  # Method to create a rental
  def create_rental(book, person, date)
    rental = Rental.new(book, person, date)
    @rentals << rental
    puts "Rental created successfully for '#{book.title}' by #{person.name} on #{date}."
  end

  # Method to list all rentals for a given person ID
  def list_rentals_for_person(person_id)
    person = @people.find { |p| p.id == person_id }
    if person
      person_rentals = @rentals.select { |rental| rental.person == person }
      if person_rentals.any?
        puts "Rentals for #{person.name}:"
        person_rentals.each do |rental|
          puts "#{rental.book.title} on #{rental.date}"
        end
      else
        puts "No rentals found for #{person.name}."
      end
    else
      puts "Person with ID #{person_id} not found."
    end
  end
end
