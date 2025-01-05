# Cosensee

Cosensee is a tool that reads JSON data from [Cosense](https://scrapbox.io) (formerly Scrapbox) and outputs it in HTML format.

## Installation

Install the gem:

    $ gem install cosensee

If you use bundler, add to the application's Gemfile by executing:

    $ bundle add cosensee

## Usage

To output HTML, specify the JSON file from Cosense as an argument and run `bin/build`.

    $ bin/build

The HTML files will be output to the .out directory. You can view them locally by using the bin/server command.

    $ $bin/server

The default port used by bin/server is 1212.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takahashim/cosensee.

