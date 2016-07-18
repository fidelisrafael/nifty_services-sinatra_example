## Nifty Services on Sinatra

## About

This simple API projects was developed to serve as use case and sample application for users who want to use [`nifty_services`](https://github.com/fidelisrafael/nifty_services) as Service Object Oriented in your Sinatra applications.

## Setup

First, clone this application:

`$ git clone git@github.com:fidelisrafael/nifty_services-sinatra_example.git`

Enter application folder:

`$ cd nifty_services-sinatra_example`

### Install dependencies

Install required binaries(to compile SQLite3 gem)

**Linux**

`sudo apt-get install sqlite3 libsqlite3-dev`

**Mac OS**

MacOS Leopard or later comes with SQlite3 pre installed. 

Install  gem dependencies: `$ bundle install`

### Generate database: & seed 

`$ rake db:reset`

Make sure `log/seeds.log` was created, otherwise, execute: `$ rake db:seed` to create default admin user and sample posts and comments.

### Run application:

```
$ rackup config.ru -p 9292
INFO  WEBrick 1.3.1
INFO  ruby 2.3.0 (2015-12-25) [x86_64-linux]
INFO  WEBrick::HTTPServer#start: pid=9840 port=9292
```

## Postman Collection

To start working with endpoints, you can use [**Postman**](https://www.getpostman.com/) to interact with endpoints, the screenshot belows show an endpoint response:

![Postman Screenshoft](http://i.imgur.com/InkbowF.png)

First install Postman, and then use the following link to import this collection:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/920e58a62075beee09f0)

After importing, you must set the following **environment variables**

`nifty_services_sinatra_host = http://localhost:9292/api`
 
 Make sure you're running the correct environment and start playing with endpoints.

While playing around, try modifying some values in the URL, such the `ids` to see all responses formats (`422`, `404`, `403`, `400`), send invalid `auth_tokens` and try to update or delete resources which don't belongs to `current_user`, just to give a better ideia of the whole thing.

## Log

While playing with endpoints in Postman, run another bash terminal and execute:

`$ tail -f log/app_services.log` to follow services logs.


## Endpoints

In this application there are a few endpoints to demonstrate all capabilities of `Nifty Services`, there are samples of `CRUD Services` and `ActionServices`, as listed below:

#### Services list 
![](http://i.imgur.com/fTmAude.png)

Take a look in in services for 

* **Users**
   * [CreateService](app/services/v1/users/create_service.rb) *(Demonstrate custom validations and on the fly `record_attributes_whitelist` for allowing specific attributes based on options)*
   * [AuthService](app/services/v1/users/auth_service.rb) *(Demonstrate BaseService usage)*
   *  [ActivateUserAccountService](app/services/v1/users/auth_service.rb) *(Demonstrates silly different usage of BaseUpdate)*
   * [ActivationMailDeliveryService](app/services/v1/users/activation_mail_delivery_service.rb) *(Demonstrates BaseActionService usage)*

* **Posts**
   * [CreateService](app/services/v1/posts/create_service.rb) *(Demonstrates the usage of `build_record_scope` and `on_save_record_error` methods)*
   * [UpdateService](app/services/v1/posts/update_service.rb)
   * [DeleteService](app/services/v1/posts/delete_service.rb)
  
* **Comments**
   * [CreateService](app/services/v1/comments/create_service.rb) *(Demonstrates how to override `build_record` method to create custom objects)*
   * [UpdateService](app/services/v1/comments/update_service.rb) *(I'm in love)*
   * [DeleteService](app/services/v1/comments/delete_service.rb) *(How can be so simple? <3)*
* **System**
  * [SeedService](app/services/v1/system/seed_service.rb) *(Demonstrates BaseActionService usage plus how to use multiples services together )* 

Want to see all services working together? See [**System::SeedService**](app/services/v1/system/seed_service.rb) who is responsible to create initial seed data across application. (the sames services used here, are used in endpoints, this is the aim of NiftyServices, allow bussiness logic to be shared, reused and used as components)

## Endpoints simplicity

Your controllers files must be very tiny and readable when using `NiftyServices`, see for example the CRUD controller for `Posts`:

```ruby
post do
  service = execute_service('Posts::CreateService', current_user, service_params(:post))

  json response_for_create_service(service, :post)
end

delete '/:id' do
  post = fetch_post_for(current_user, params[:id])

  service = execute_service('Posts::DeleteService', post, current_user)

  json response_for_delete_service(service, :post)
end

put '/:id' do
  post =  fetch_post_for(current_user, params[:id])
  service = execute_service('Posts::UpdateService', post, current_user, params)

  json response_for_update_service(service, :post)
end
```

See the `/controllers/v1`(app/controllers/v1) folder to get amazed with organization and readability \o/ 

## Futher info

See [`nifty_services`](https://github.com/fidelisrafael/nifty_services) documentation.
