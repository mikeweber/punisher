require 'bundler'
Bundler.setup
require 'net/https'
require 'json'
require 'markov_chain'

def print_usage
  puts <<~EOS
    Train the system first by specifying the number of [training_rounds] and cached [training_file].
    usage: ruby punisher.rb train [training_rounds={1]] [training_file={trainings.txt}]

    Print out [num_of_jokes_to_make] jokes based on the cached [training_file].
    usage: ruby punisher.rb joke [num_of_jokes_to_make={1}] [training_file={trainings.txt}]
  EOS
end

def run(rounds, jokes)
  make_jokes(MarkovChain::Chain.new(train(rounds)), jokes)
end

def read_training_and_make_jokes(jokes, filename)
  unless File.exists?(filename)
    puts('The system must be trained before jokes can be made.')
    return
  end

  chain = MarkovChain::Chain.new(read_cache(filename))
  make_jokes(chain, jokes)
end

def make_jokes(chain, jokes)
  jokes.times { puts chain.generate }
end

def train_and_cache(rounds, filename = 'trainings.txt')
  list = File.exists?(filename) ? read_cache(filename) : MarkovChain::WordList.new
  cache_training(train(rounds, list), filename)
end

def cache_training(list, filename)
  File.open(filename, 'w') do |f|
    list.words.each do |word|
      word.tails.each do |tail, count|
        f.puts [word.to_s, tail.to_s, count, ('1' if list.start_words.include?(word))].join("\t")
      end
    end
  end
end

def read_cache(filename)
  list = MarkovChain::WordList.new
  File.open(filename).each.with_index do |line, index|
    word, tail, count, is_start_word = line.split("\t")
    list.add_start_word(word) if is_start_word.to_i == 1
    tail = MarkovChain::Terminator.new if tail == ''
    list.add_pair(word, tail, count.to_i)
  end
  list
end

def train(num, list = MarkovChain::WordList.new)
  uri = URI('https://icanhazdadjoke.com')
  req = request(uri)
  num.times do
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    joke = JSON.parse(res.body)['joke']
    list.add(joke)
  end

  list
end

def request(uri)
  Net::HTTP::Get.new(uri).tap { |req| req['Accept'] = 'application/json'; req['User-Agent'] = "Punisher (https://github.com/mikeweber/punisher)"}
end

case ARGV[0]
when 'joke'
  read_training_and_make_jokes((ARGV[1] || 1).to_i, (ARGV[2] || 'trainings.txt'))
when 'train'
  train_and_cache((ARGV[1] || 1).to_i, (ARGV[2] || 'trainings.txt'))
else
  print_usage
end
