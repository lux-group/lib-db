#!/usr/bin/env node

const shell = require('shelljs')
const path = require('path')
const fs = require('fs')
const ini = require('ini')
require('dotenv').config()
const parseDatabaseUrl = require('parse-database-url')

process.on('unhandledRejection', err => {
  throw err
})

const VALID_COMMANDS = [{
  name: 'heroku-pull-test',
  script: './heroku/db-pull-test.sh'
}, {
  name: 'heroku-capture-test',
  script: './heroku/db-capture-test.sh'
}, {
  name: 'heroku-restore-test',
  script: './heroku/db-restore-test.sh'
}, {
  name: 'heroku-backup-test',
  script: './heroku/db-backup-test.sh'
}, {
  name: 'heroku-pull-prod',
  script: './heroku/db-pull-prod.sh'
}, {
  name: 'snapshot',
  script: './db-snapshot.sh'
}, {
  name: 'snapshot-restore',
  script: './db-snapshot-restore.sh'
}, {
  name: 'migrate-create',
  script: './db-migrate-create.sh'
}, {
  name: 'create',
  script: './db-create.sh'
}, {
  name: 'drop',
  script: './db-drop.sh'
}, {
  name: 'schema',
  script: './db-schema.sh'
}]

const args = process.argv.slice(2)
const command = args[0]

if (!command) {
  console.error(`No command provided, valid commands are (${VALID_COMMANDS.map(c => c.name).join(',')})`)
  process.exit(1)
}

const commandReference = VALID_COMMANDS.find(c => c.name === command)

if (!commandReference) {
  console.error(`Invalid command provided (${command}), valid commands are (${VALID_COMMANDS.map(c => c.name).join(',')})`)
  process.exit(1)
}

let env = {
  ...process.env
}

if (env.DATABASE_URL) {
  dbConfig = parseDatabaseUrl(env.DATABASE_URL)
  env = {
    ...env,
    PGPORT: dbConfig.port || 5432,
  }
  console.log(`Using port from DATABASE_URL: ${env.PGPORT}`)
}

const pathToConfig = path.resolve('.lib-db.config')

if (fs.existsSync(pathToConfig)) {
  console.log('Found config at', pathToConfig)
  const config = ini.parse(fs.readFileSync(pathToConfig, 'utf-8'))
  if (config) {
    env = { ...config, ...env }
  }
}

const pathToScript = path.resolve(__dirname, '..', 'scripts', commandReference.script)

shell.exec(`${pathToScript} ${args.slice(1).join(' ')}`, { env }, function (code, stdout, stderr) {
  process.exit(code)
})
