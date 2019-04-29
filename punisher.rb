require 'bundler'
Bundler.setup
require 'net/https'
require 'json'
require 'markov_chain'
require_relative './lib/trainer'

include Trainer
def print_usage
  puts <<~EOS
    Train the system first by specifying the number of [training_rounds] and cached [training_file].
    usage: ruby punisher.rb train [training_rounds={1]] [training_file={trainings.txt}]

    Print out [num_of_jokes_to_make] jokes based on the cached [training_file].
    usage: ruby punisher.rb joke [num_of_jokes_to_make={1}] [training_file={trainings.txt}]
  EOS
end

case ARGV[0]
when 'joke'
  read_cache_and_make_jokes((ARGV[1] || 1).to_i, (ARGV[2] || 'trainings.txt'))
when 'train'
  train_and_cache((ARGV[1] || 1).to_i, (ARGV[2] || 'trainings.txt'))
else
  print_usage
end
