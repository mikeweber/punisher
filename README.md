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

Start by training the system. To avoid overloading the API, it is suggested to only
train 100 jokes or less at a time. The trainings are additive, so each training session
will add to the previous session.
```
  $ ruby punisher.rb train 5
```

Once the system has been trained, you can generate a joke (or multiple at once) by
specifying how many jokes to make.
```
  $ ruby punisher.rb joke 10
```
