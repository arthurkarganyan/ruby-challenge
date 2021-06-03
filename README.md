# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Comments

For interaction with OMDb API `httparty` gem is used (file `lib/obdb_api.rb`).

For storing OMDB API key gem `dotenv` is used, which loads `.env` file from the root of the application. 
That makes accessible `ENV['OMDB_API_KEY']`. Also `.env` file should be gitignored.