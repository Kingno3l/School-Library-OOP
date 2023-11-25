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

  def list_all_books
    @books.each do |book|
      puts "Title: #{book.title}"
      puts "Author: #{book.author}"
    end
  end

  def list_all_people
    puts 'Students:'
    @people.each { |person| puts "Name: #{person.name} ID: #{person.id} Age: #{person.age}" if person.is_a?(Student) }

    puts "\nTeachers:"
    @people.each { |person| puts "Name: #{person.name} ID: #{person.id} Age: #{person.age}" if person.is_a?(Teacher) }
  end

  def create_person(type, age, name, parent_permission: true, specialization: nil)
    if type == 'teacher'
      person = Teacher.new(age, name, specialization)
    elsif type == 'student'
      person = Student.new(age, name, parent_permission)
    else
      puts 'Invalid person type!'
      return
    end
    @people << person
    puts "#{type.capitalize} #{person.name} created successfully!"
  end

  def create_book(title, author)
    book = Book.new(title, author)
    @books << book
    puts 'Book created successfully!'
  end

  def create_rental(book, person, date)
    rental = Rental.new(book, person, date)
    @rentals << rental
    puts "Rental created successfully for '#{book.title}' by #{person.name} on #{date}."
  end

  def list_rentals_for_person(person_id)
    person = @people.find { |p| p.id == person_id }
    if person
      person_rentals = @rentals.select { |rental| rental.person == person }
      if person_rentals.any?
        puts "Rentals for #{person.name}:"
        person_rentals.each { |rental| puts "#{rental.book.title} on #{rental.date}" }
      else
        puts "No rentals found for #{person.name}."
      end
    else
      puts "Person with ID #{person_id} not found."
    end
  end
end
