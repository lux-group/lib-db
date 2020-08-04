#!/usr/bin/env node

const shell = require('shelljs')
const path = require('path')
const fs = require('fs')
const ini = require('ini')

process.on('unhandledRejection', err => {
  throw err
})

const VALID_COMMANDS = [{
  name: 'heroku-pull-test',
  script: './heroku/db-pull-test.sh [HOST] [PORT]'
}, {
  name: 'heroku-pull-prod',
  script: './heroku/db-pull-prod.sh [HOST] [PORT]'
}, {
  name: 'snapshot',
  script: './db-snapshot.sh [HOST] [PORT]'
}, {
  name: 'snapshot-restore',
  script: './db-snapshot-restore.sh [HOST] [PORT]'
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

const pathToConfig = path.resolve('.lib-db.config')

if (fs.existsSync(pathToConfig)) {
  console.log('Found config at', pathToConfig)
  const config = ini.parse(fs.readFileSync(pathToConfig, 'utf-8'))
  if (config) {
    env = {...env, ...config}
  }
}

const pathToScript = path.resolve(__dirname, '..', 'scripts', commandReference.script)

shell.exec(`${pathToScript} ${args.slice(1).join(' ')}`, { env }, function(code, stdout, stderr) {
  process.exit(code)
})
