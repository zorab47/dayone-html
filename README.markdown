# Quick and Dirty [Day One][1] HTML Export

I created this to export my Day One App entries into a format more
suited for printing to a book.

It runs on Ruby (Sinatra) and requires you store your posts in
Dropbox rather than iCloud.

It's not very flexible. You'll need to know your way around Ruby /
Sinatra to get it customized to your liking.

![screenshot](https://cloud.githubusercontent.com/assets/25094/8538675/aa9c28dc-2435-11e5-85e2-e11b3b9e8053.png)

## Enhancements

- Allow multiple journals to be merged together into one view.
- Provide location, weather, and star status metadata for entries.
- Update styles to be more familiar to those from Day One.

## Installation

### Prerequisites

* Ruby 2.0+
* [imagemagick][2]

### Steps

Open Terminal and run the following commands:

1. `git clone https://github.com/zorab47/dayone-html.git`
2. `cd dayone-html`
3. `bundle install`
4. `bundle exec ruby dayone.html.rb`

Now visit localhost:4567 to see your journal in HTML!

[1]: http://dayoneapp.com/
[2]: http://www.imagemagick.org
