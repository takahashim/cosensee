# Cosensee

Cosensee is a tool that reads JSON data from [Cosense](https://scrapbox.io) (formerly Scrapbox) and outputs it in HTML format.

## Installation

Install the gem:

    $ gem install cosensee

If you use bundler, add to the application's Gemfile by executing:

    $ bundle add cosensee

## Usage

First, create project directory and move to it.

    $ cosensee --init <project dir>
    $ cd <project dir>

To output HTML, specify the JSON file from Cosense as an argument and run `cosensee` with Cosense JSON page-data file.

    $ cosensee -f <json file>

If you want to output the HTML file to a directory other than `public`, use the `-d` option.

The HTML files will be output to the `public` directory. You can view them locally by using the `-s` option.

    $ cosensee -f <json file> -s

The default port used by the local server is `1212`. If you want to change the port, use the `-p` option.

    $ cosensee -f <json file> -s -p 3000

You can also use the `-h` option to display the help message.

    $ cosensee --help

## Deploy

Cosensee outputs static HTML and CSS files, so they can be deployed as-is.
Use the tools and resources specific to the environment you want to deploy to.

For example, in the case of Cloudflare Pages, you can deploy using [Wrangler](https://developers.cloudflare.com/workers/wrangler/) as follows:

    $ npx wrangler pages deploy dist --project-name <cloudflare project name>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takahashim/cosensee.

