# README

## development

### install dependencies

    bundle install
    yarn install

### prepare local dev db

Create db and seed some testdata.

    rake db:migrate
    rake db:seed

### run

    rails server

goto: http://localhost:3000

### login if started locally

There is a seeded user you can use to login:

Username: test@test.de / Password: supersicher

## Hints

### Annotate model with attributes

	annotate --models
	annotate --routes

## Production deployment

### DB migration

    docker exec -it my-app-container bash
    /app/scripts/db_migrate.sh

### Create a user

    docker exec -it my-app-container bash
    /app/scripts/console.sh

    User.create(:email => "my-email", :password => 'my-password', :password_confirmation => 'my-password')
