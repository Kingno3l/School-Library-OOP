require_relative 'app'
require_relative 'person'
require_relative 'capitalize_decorator'
require_relative 'trimmer_decorator'

def display_options
  puts "Choose an option:"
  puts "1. List all books"
  puts "2. List all people"
  puts "3. Create a person"
  puts "4. Create a book"
  puts "5. Create a rental"
  puts "6. List all rentals for a given person ID"
  puts "7. Quit"
end

def main
  app = App.new

  loop do
    display_options
    choice = gets.chomp.to_i

    case choice
    when 1
      app.list_all_books
    when 2
      app.list_all_people
    when 3
      puts "Do you want to create a student (1) or a teacher (2)? [Input the number]:"
      person_type = gets.chomp.to_i

      case person_type
      when 1
        id = rand(1..100) 
        
        puts "Age:"
        age = gets.chomp.to_i

        puts "Name:"
        name = gets.chomp

        puts "Has parent permission? [Y/N]:"
        parent_permission_input = gets.chomp.downcase
        parent_permission = parent_permission_input == 'y' ? true : false

        app.create_person('student', id, age, name, parent_permission)
        puts "Student created successfully!"

      when 2
        puts "Enter teacher ID, age, name, parent permission (true/false):"
        id, age, name, parent_permission = gets.chomp.split.map(&:to_i)
        app.create_person('teacher', id, age, name, parent_permission)
      else
        puts "Invalid person type choice."
      end
    when 4
      puts "Enter book title and author:"
      title, author = gets.chomp.split(',')
      app.create_book(title, author)
    when 5
      puts "Enter book index, person ID, and date (YYYY-MM-DD):"
      book_index, person_id, date = gets.chomp.split(',')
      book = app.books[book_index.to_i]
      person = app.people.find { |p| p.id == person_id.to_i }
      app.create_rental(book, person, date)
    when 6
      puts "Enter person ID:"
      person_id = gets.chomp.to_i
      app.list_rentals_for_person(person_id)
    when 7
      break
    else
      puts "Invalid choice. Try again."
    end
  end
end

# def execute_decorator_example
#   person = Person.new(22, 'maximilianus')
#   puts person.correct_name

#   capitalized_person = CapitalizeDecorator.new(person)
#   puts capitalized_person.correct_name

#   capitalized_trimmed_person = TrimmerDecorator.new(capitalized_person)
#   puts capitalized_trimmed_person.correct_name
# end

main if __FILE__ == $PROGRAM_NAME
execute_decorator_example
