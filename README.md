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

Username: test@test.de Password: supersicher

## Hints

### Annotate model with attributes

	annotate --models
	annotate --routes

## TODOs

### Membership model

* show membership ID
* date as only DD-MM-YYYY
* now as start date and empty end date on creation
* distribution point as enum

### Transaction model

* import from csv (with deduplication of existing) (/)
* cleanup csv (remove newlines, quotes)
* deduplicate transactions on import

### Login

* find some gem

