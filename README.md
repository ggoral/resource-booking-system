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

## TODO
> Test que faltan: `grep -i 'get\|post\|put\|delete' app.rb` 

* delete '/resources/:resource_id/bookings/:booking_id'
* ~~get '/resources'~~
* ~~get '/resources/:resource_id'~~
* ~~get '/resources/:resource_id/availability'~~
* ~~get '/resources/:resource_id/bookings'~~ **FIX too many methods**
* get '/resources/:resource_id/bookings/:booking_id'
* ~~post '/resources'~~
* post '/resources/:resource_id/bookings'
* ~~put '/resources/:resource_id'~~
* put '/resources/:resource_id/bookings/:booking_id' 

Los recursos de la API no se asocian a una entidad, por lo tanto los recursos
serán comunes a todos los proyectos redmine. Si desea puede modificar la API
agregando a los recursos un campo entity al recurso que podría usarse en este
caso como id de proyecto. Entonces, la API debería agregar un servicio:

  * `GET /resources_for_entity/:entity` que devolvería los recursos para una
    entidad específica

Sería conveniente agregar en la API un servicio de agregado y modificación de
recursos:

  * `POST /resources` crea un nuevo recurso (terminado)
  * `PUT /resources/:id` actualiza los datos de un recurso (validar test)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See the [LICENSE](https://github.com/svenfuchs/micro_migrations/blob/master/LICENSE).
