def create_rental
  puts 'Select a book from the following list by number:'
  @books.each_with_index { |book, index| puts "#{index + 1}. #{book.title} by #{book.author}" }
  book_index = gets.chomp.to_i - 1

  if book_index.negative? || book_index >= @books.length
    puts 'Invalid book selection!'
    return
  end

  selected_book = @books[book_index]

  puts 'Select a person from the following list by number:'
  @people.each_with_index do |person, index|
    puts "#{index + 1}. Name: #{person.name} ID: #{person.id} Age: #{person.age}"
  end
  person_index = gets.chomp.to_i - 1

  if person_index.negative? || person_index >= @people.length
    puts 'Invalid person selection!'
    return
  end

  selected_person = @people[person_index]

  puts 'Enter the date (YYYY-MM-DD):'
  date = gets.chomp

  rental = Rental.new(selected_book, selected_person, date)
  @rentals << rental

  puts "Rental created successfully for '#{selected_book.title}' by #{selected_person.name} on #{date}."
end
