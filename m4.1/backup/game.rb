require 'net/http'
require 'json'
require 'logger'

# logger = Logger.new(STDOUT)

# logger.level = Logger::WARN

def logger
  logger = Logger.new(STDOUT)
  logger.level = Logger::INFO
  logger
end

class Game
  def initialize(secret_word)
    @secret_word = secret_word
    @hash_map = {}
  end
  
  def set_hashmap(key, value)
    logger.info("Inputting new instance to hashmap (#{key}: #{value})")
    @hash_map[key] = value
  end
  
  def match_word(guess_word)
    result = "\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}\u{1F7E6}"
    
    logger.info("HASHMAP NOW: #{@hash_map}")
    if @hash_map.key?(guess_word)
      logger.info("Returning from hashmap")
      return @hash_map[guess_word]
    end
    # check length of word
    # SHOULD BE PLACED ON TOP. WHY?
    if guess_word.length != @secret_word.length
      # IT'S IMPORTANT TO PUT ERROR MESSAGE
      puts "Please input a word with a length of #{@secret_word.length}"
      set_hashmap(guess_word, result)
      return result
    end
    
    # check if word is in english dictionary
    uri = URI('https://api.dictionaryapi.dev/api/v2/entries/en/' + guess_word)
    response = Net::HTTP.get(uri)
    response_json = JSON.parse(response)
    
    if response_json.class == Hash && response_json['title'] == "No Definitions Found"
      puts 'Please input a valid English word'
      set_hashmap(guess_word, result)
      return result
    end
    
    guess_word.split('').each_with_index do |letter, index|
      if @secret_word[index] == letter
        result[index] = "\u{1F7E9}"
      elsif @secret_word.include?(letter)
        result[index] = "\u{1F7E8}"
      end
    end
    
    set_hashmap(guess_word, result)
    return result
  end
end