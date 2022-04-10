require_relative 'lib/game'

game = Game.new('SPEED')

loop do
  puts 'Your guess:'
  guess_word = gets.chomp()
  result = game.match_word(guess_word)
  puts result
  break if result == "\u{1F7E9}\u{1F7E9}\u{1F7E9}\u{1F7E9}\u{1F7E9}"
end