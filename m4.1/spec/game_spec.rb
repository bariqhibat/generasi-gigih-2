require 'game'


# The outer block called a spec group
# This is where we specify what we want to build, in this case a Game class
describe 'Game' do
    
    # This inner block is another spec group
    # The convention is to use #name_of_method to define group of specs for a behavior
    describe '#match_word' do
    
    # The most inner block specifies a scenario
    # In this case, we are specifying that 
    # when given all incorrect letters as guess_word,
    # match_word will return "\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}"
    # which is the ASCII code for 🟦🟦🟦🟦🟦
    it 'should handle all incorrect letters well' do
        # The following spec structure is known as given-when-then
        
        # Given we have a game object with secret_word 'DRINK'
        # and guess_word is 'HELLO'
        game = Game.new('DRINK')
        guess_word = 'HELLO'
        
        # When we try to match the guess_word with secret word using match_word method
        result = game.match_word(guess_word)
        
        # Then it should return 🟦🟦🟦🟦🟦
        expect(result).to eq("\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}")
    end
    
    
    # One additional spec for new scenario: wrongly positioned letter
    it 'should handle a wrongly positioned letter well' do
        # Given a game object with secret_word 'DRINK'
        # and guess_word 'CLEAN' (N is a correct letter but in wrong position)
        game = Game.new('DRINK')
        guess_word = 'CLEAN'
        
        # When we try to match the guess word
        result = game.match_word(guess_word)
        
        # Then it should return "\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E8}"
        # which is the ASCII code for 🟦🟦🟦🟦🟨
        expect(result).to eq("\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E8}")
    end
    
    # This is our new spec.
    # By now you should have already understood the structure of this spec
    it 'should handle a correctly positioned letter well' do
        game = Game.new('DRINK')
        guess_word = 'ALIVE'
        
        result = game.match_word(guess_word)
        
        expect(result).to eq("\u{1F7E6}\u{1F7E6}\u{1F7E9}\u{1F7E6}\u{1F7E6}")
    end
    
    # Isn't english word
    it 'should handle an incorrect English word' do
        game = Game.new('DRINK')
        guess_word = 'ASDASD'

        result = game.match_word(guess_word)

        expect(result).to eq("\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}")
    end

    # Isn't english word
    it 'should handle an invalid length of word' do
        game = Game.new('DRINK')
        guess_word = 'FUN'

        result = game.match_word(guess_word)

        expect(result).to eq("\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}")

        guess_word = 'GENEROUS'

        result = game.match_word(guess_word)

        expect(result).to eq("\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}")
    end

end

end