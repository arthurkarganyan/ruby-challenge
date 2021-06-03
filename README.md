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

I took the conservative approach and used SQL database (SQLite, but Postgres for production), which seems to provide more data consistency and better relations (useful in case of adding new filters or functionality based on film's attributes), but NoSQL also could be used (e.g. MongoDB). Mongo could be faster to prototype, but should be used with caution, e.g. the data from 3-d party can be corrupted, but still saved to the database and thus shown to users.

For converting data from OMDB Api format to database format I use `Film#new_from_omdb_api` method (with test coverage in `spec/models/film_spec.rb`). Some devs would argue, that it would be better to move it to service object and I agree, but I don't want to introduce complexity too early.

The data types and fields names I've chosen are more based on my intuition rather then real cases, because I don't have the full picture yet. And I foresee possible migrations from one data type to another (e.g. make `box_office` integer and store currency - but only if this will be needed). For me, the important part is consistency, e.g. `imdbRating` is camelcase, but in Ruby snake case `imdb_rating` is the convention.