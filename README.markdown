# Riot Rails

[Riot](http://github.com/thumblemonks/riot) macros for Rails application testing.

LOTS more to come ...

## Installation

We're a gem! Install per the normal course of installing gems.

    gem install riot_rails

## Usage

Tons of documentation to come. Try looking at the [RDoc](http://rdoc.info/projects/thumblemonks/riot_rails) for now. As a note, you will likely put this in your `teststrap.rb` or `test_helper.rb`:

    require 'riot/rails'

That will add support for everything Riot Rails supports. If you only need ActiveRecord support - for example - do something like this:

    require 'riot'
    require 'riot/active_record'

### ActiveRecord

Awesome stuff in the works. Doc coming soon.

### ActionController

Awesome stuff in the works. Doc coming soon.

### ActionMailer

Awesome stuff coming soon. See [Shoulda Action Mailer](http://github.com/thumblemonks/shoulda_action_mailer) - which is also by us - in the meantime.

I told you we liked Shoulda.
