def random_email_address
  "#{random_string}@example.com"
end

def random_string
  random_alpha_string_of_length(10)
end

def random_alpha_string_of_length(length)
  letters = *'a'..'z'
  random_string_for_uniqueness = ''
  length.times { random_string_for_uniqueness += letters[rand(letters.size - 1)]}
  random_string_for_uniqueness
end

def random_number_string_of_length(length)
  numbers = *'0'..'9'
  random_string_for_uniqueness = ''
  length.times { random_string_for_uniqueness += numbers[rand(numbers.size - 1)]}
  random_string_for_uniqueness
end
