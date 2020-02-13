# lib-db

Common database scripts

## Installation

```sh
yarn add @luxuryescapes/lib-db
```

## Configuration

You can optionally create a file called `.lib-db.config` to specify configuration
This file format should be key value like below

```
APP_NAME=my_app
TEST_HEROKU_APP_NAME=my_heroku_app_name
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

You can omit the arguments if you have `APP_NAME` and `TEST_HEROKU_APP_NAME` defined in your `.lib-db.config` file

### heroku-pull-prod

`lib-db heroku-pull-prod <app_name> <heroku_app_name>`

This script just prints an error at the moment


### snapshot

`lib-db snapshot <app_name>`

Will snapshot your db named `<app_name>_development` into `<app_name>_development_snapshot`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file

### snapshot-restore

`lib-db snapshot-restore <app_name>`

Will restore your snapshot in `<app_name>_development_snapshot` into `<app_name>_development`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file