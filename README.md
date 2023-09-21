# lib-db

Common database scripts. These scripts require a postgres db container to be running. You can start these here [infra-le-local-dev](https://github.com/lux-group/infra-le-local-dev)

## Installation

See [example PR](https://github.com/lux-group/svc-payment/pull/524/files), or follow instructions below:

```sh
yarn add -D @luxuryescapes/lib-db
```

## Configuration

You can optionally create a file called `.lib-db.config` to specify configuration
This file format should be key value like below

```
APP_NAME=my_app
TEST_HEROKU_APP_NAME=my_heroku_app_name
DB_CONTAINER=postgres13
EXCLUDE_TABLES="big_table;big_table_2;personal\*"
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

Note: If the DB you are backing up is large, please consider using the [heroku-capture-test](#heroku-capture-test), [heroku-backup-test](#heroku-backup-test) & [heroku-restore-test](#heroku-restore-test) commands instead.

`lib-db heroku-pull-test <app_name> <heroku_app_name>`

This script will pull down the database from the specified heroku app into a database called `<app_name>_development`

So for example if you do the following

`lib-db heroku-pull-test svc_users test-svc-users`

It will pull down the database from the heroku app named `test-svc-users` into a local db named `svc_users_development`

You can omit the arguments if you have `APP_NAME` and `TEST_HEROKU_APP_NAME` defined in your `.lib-db.config` file

You can omit table table by setting the `EXCLUDE_TABLES` env var in `.lib-db.config` this is a `;` seperated list of table names. Make sure you quote this list so the `;` character is escaped. If you are using a wildcard `*` this will need to be explicitly escaped

### heroku-pull-prod

`lib-db heroku-pull-prod <app_name> <heroku_app_name>`

This script just prints an error at the moment

### <a name="heroku-capture-test"></a> heroku-capture-test

`lib-db heroku-capture-test <app_name> <heroku_app_name>`
This script will generate a manual backup in heroku for downloading.

### <a name="heroku-backup-test"></a> heroku-backup-test

`lib-db heroku-backup-test <app_name> <heroku_app_name>`
This script will download a backup of the database from the specified heroku app.

### <a name="heroku-restore-test"></a> heroku-restore-test

`lib-db heroku-restore-test <app_name> <heroku_app_name>`
This script will restore a backup of the database of the specified heroku app that is stored in your local container. Please run `heroku-backup-test` first to download the backup.

### create

`lib-db create <app_name>`

Will create your db named `<app_name>_development`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file

If you want to create a db for a different environment use the env var `APP_ENV`

e.g running `APP_ENV=spec lib-db create my_app` will create a db named `my_app_spec`

### drop

`lib-db drop <app_name>`

Will drop your db named `<app_name>_development`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file

If you want to drop a db for a different environment use the env var `APP_ENV`

e.g running `APP_ENV=spec lib-db drop my_app` will drop a db named `my_app_spec`

### schema

`lib-db schema <app_name>`

Will export the schema of db named `<app_name>_development` to `repo/schema.sql`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file

If you want to export the schema for a db for a different environment use the env var `APP_ENV`

e.g running `APP_ENV=spec lib-db schema my_app` will export the schema from the db named `my_app_spec`
Alternatively you can define a different location using the `REPO_DIRECTORY` in your `.lib-db.config` file

### snapshot

`lib-db snapshot <app_name>`

Will snapshot your db named `<app_name>_development` into `<app_name>_development_snapshot`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file

### snapshot-restore

`lib-db snapshot-restore <app_name>`

Will restore your snapshot in `<app_name>_development_snapshot` into `<app_name>_development`

You can omit the argument if you have `APP_NAME` defined in your `.lib-db.config` file

### migrate-create

`lib-db migrate-create <migration_name> <app_name>`

This will create a migration sql file. By default it will put it in the `migrations` folder within the `repo` folder which is relative to where you ran the command
Alternatively you can define a different location using the `REPO_DIRECTORY` in your `.lib-db.config` file

You can omit the app_name argument if you have `APP_NAME` defined in your `.lib-db.config` file

### No Postgres with Docker usage

`lib-db heroku-pull-test-no-docker`
Use this command if you are not running the Postgres DB in Docker, but still want to be able to pull from the DB in test environment for you service