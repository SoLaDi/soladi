# SoLaDi

This is a software designed to make the management of a solidaric agriculture community easier.

## Build status:
[![CircleCI](https://circleci.com/gh/SoLaDi/soladi.svg?style=shield)](https://circleci.com/gh/SoLaDi/soladi)

## development

### prepare the stage (MacOS)
   
    brew install rbenv nvm

    rbenv install 3.0.5
    rbenv global 3.0.5

    nvm install v12.22.7
    npm install --target_arch=x64

### setup NVM to switch automatically to `.nvmrc` version

https://github.com/nvm-sh/nvm#zsh

    

### install dependencies

    bundle install
    yarn install

    # if no yarn for current node version
    npm install --global yarn@v1.22.17

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

### Test email delivery and templates

https://mailtrap.io offers a free account and directly after registration you see how to configure rails to use it.

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
