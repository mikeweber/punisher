require 'bundler'
Bundler.setup
require 'net/https'
require 'json'
require 'markov_chain'

def print_usage
  puts <<~EOS
    Print out a joke after the system has trained from [training_rounds] number of jokes.
    usage: punisher.rb new [training_rounds={1}] [jokes_to_print={1}]
  EOS
end

def run(rounds, jokes)
  chain = MarkovChain::Chain.new(train(rounds))
  jokes.times { puts chain.generate }
end

def train(num)
  list = MarkovChain::WordList.new

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
when 'new'
  run((ARGV[1] || 1).to_i, (ARGV[2] || 1).to_i)
else
  print_usage
end
