#!/usr/bin/env node

const shell = require('shelljs')
const path = require('path')

process.on('unhandledRejection', err => {
  throw err
})

const VALID_COMMANDS = [{
  name: 'heroku-pull-test',
  script: './heroku/db-pull-test.sh'
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

const pathToScript = path.resolve(__dirname, '..', commandReference.script)

shell.exec(`${pathToScript} ${args.slice(1).join(' ')}`, function(code, stdout, stderr) {
  process.exit(code)
})
