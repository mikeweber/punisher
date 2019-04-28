# The Punisher

Doing to puns what puns do to their victims.

# Background

This tool grabs jokes from the [ICanHazDadJoke API](https://icanhazdadjoke.com/api),
analyzes the likelihood of a sequence of words being connected together, and builds
a Markov chain, which can be later used to generate a new "joke."

# Installation

This project requires Ruby 2.6.3, RubyGems and Bundler. Assuming Ruby
and RubyGems have been installed, the rest of this project's dependencies
can be installed with bundler.
```
  $ gem install bundler
  $ bundle
```

# Usage

Pass in the number of jokes to train against, and the number of jokes generate, just for you!
The following example will generate 10 jokes based on 100 existing jokes
```
  $ ruby punisher.rb new 100 10
```
