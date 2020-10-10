'use strict'

const DynamoTable = require('./services/dynamo')

const gamesTable = new DynamoTable(process.env.GAMES_TABLE)

exports.handler = async (event, context, callback) => {
  const games = await gamesTable.scan()
  callback(null, games)
}
