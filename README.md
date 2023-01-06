# README

* Clone this repo and within it, run `bundle install`.
* Create the database: `rake db:setup && rake db:migrate && rake db:seed`
* Run redis: `redis-server`
* Run the app: `rails server`.
* Run the valet runner: `rake valet`.

<h2>How it works</h2>
Valet runner will write & delete to and from the Redis database to simulate parking sessions across multiple garages. This application makes this data available via API request.