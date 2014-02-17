# Sinatra App Template

This is a [Sinatra](https://github.com/sinatra/sinatra) application template.

## Installation

Clone this repository.

```bash
$ git clone git@github.com/TTPS-ruby/sinatra_app_template.git
```

Remove the origin:

```bash
$ git remote rm origin
```

And then execute:

```bash
$ bundle
```

## Run the app

```bash
$ bundle exec rackup
```

## Run the test suite

```bash
$ bundle exec rake
```

## Run console test sample

```bash
$ curl -G --data 'param1=value1&param2=value2' -vvv http://localhost:9292/
```
## Add methods for load databases on app.rb
~~~~~ ruby
get '/load' do
  #Load a clean development database to test
  ActiveRecord::Base.connection.execute('DELETE FROM SQLITE_SEQUENCE WHERE name="resources";') 
  ActiveRecord::Base.connection.execute('DELETE FROM SQLITE_SEQUENCE WHERE name="bookings";')
  Resource.destroy_all
  Booking.destroy_all
  
  resource = Resource.create( 
    name: 'Computadora', 
    description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')
  
  booking = resource.bookings.create(
    start: "2013-10-26T10:00:00Z".to_time.utc.iso8601, 
    end: ("2013-10-26T11:00:00Z".to_time.utc.iso8601), 
    status: 'approved', 
    user: 'someuser@gmail.com')
  
  booking.update(status: 'approved')
  booking = resource.bookings.create(
    start: "2013-10-26T11:00:00Z".to_time.utc.iso8601,
    end: ("2013-10-26T12:30:00Z".to_time.utc.iso8601), 
    status: 'approved', 
    user: 'otheruser@gmail.com')

  resource = Resource.create(
      name: "Monitor",
      description: "Monitor de 24 pulgadas SAMSUNG")
  
  resource = Resource.create(
      name: "Sala de reuniones",
      description: "Sala de reuniones con máquinas y proyector")
~~~~~


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See the [LICENSE](https://github.com/svenfuchs/micro_migrations/blob/master/LICENSE).
