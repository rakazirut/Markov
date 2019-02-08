module Markov
  VERSION = "0.0.1"

  class Chain
    def initialize(mc)
      @words = Hash.new
      wordList = mc.split
      wordList.each_with_index do  |word, index|
        add(word, wordList[index+1]) if index <= wordList.size - 2
      end
    end

    def add(word, nextWord)
      @words[word] = Hash.new(0) if !@words[word]
      @words[word][nextWord] += 1
    end

    def get(word)
      return "" if !@words[word]
      follow = @words[word]
      sum = follow.inject(0) { |sum,kv | sum +=kv[1]  }
      random = rand(sum)+1
      part_sum = 0
      nextWord = follow.find do |word, count|
        part_sum += count
        part_sum >= random
      end.first
      nextWord

    end

  end

  class Screen
    def pause
      STDIN.gets
    end
  end

  CONSOLE_SCREEN = Screen.new
  mc = Chain.new(File.read("mobydick.txt"))

  sentence = ""
  word = "Preliminary"
  until sentence.count(".") == 6
    sentence << word << " "
    word = mc.get(word)
  end
  puts "Seed Text: Moby Dick,  by Herman Melville (1851)\n\n"
  puts sentence << "\n\n"
  CONSOLE_SCREEN.pause

end