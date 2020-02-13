# lib-db

Common database scripts

## Installation

```sh
yarn add @luxuryescapes/lib-db
```

## Usage

Easiest way is to use in your repository's npm scripts

```json
{
  "scripts": {
    "db:pull:test": "lib-db heroku-pull-test my_app my_heroku_app_name"
  }
}
```

### heroku-pull-test

`lib-db heroku-pull-test <app_name> <heroku_app_name>`

This script will pull down the database from the specified heroku app into a database called `<app_name>_development`

So for example if you do the following

`lib-db heroku-pull-test svc_users test-svc-users`

It will pull down the database from the heroku app named `test-svc-users` into a local db named `svc_users_development`


