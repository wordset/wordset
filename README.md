[![Stories in Ready](https://badge.waffle.io/wordset/wordset.png?label=ready&title=Ready)](https://waffle.io/wordset/wordset)
# Wordset API

Wordset API is the Rails/Grape API back-end for [Wordset](https://www.wordset.org). Wordset is a collaborative, structured dictionary.

[![Travis CI](https://travis-ci.org/wordset/wordset-api.png?branch=master)](https://travis-ci.org/wordset/wordset-api)

To get it working locally, you will also need to clone and set up the Ember front-end, [Wordset UI](http://github.com/wordset/wordset-ui).

## Prerequisites

We use the latest version of Ruby, 2.1.5.
We recommend using RVM to manage Ruby versions.

This project requires MongoDB. On OS X with Homebrew, this is as easy as `brew install mongo`, but see [Mongo Installation Instructions](http://docs.mongodb.org/manual/installation/) for more information on your platform.

## Installation

* `git clone https://github.com/wordset/wordset-api.git` this repository
* change into the new directory
* `bundle install`

## Running / Development

* `rails server`
* Visit the API at [http://localhost:3000](http://localhost:3000).
* Make sure the Ember front-end ([Wordset UI](http://github.com/wordset/wordset-ui)) is running if you want to see the front-end.

### Running Tests

We use rspec for tests.

* `rspec`

## Contributing

When something breaks, or when committing a bug fix, please add a test case to the spec file.
