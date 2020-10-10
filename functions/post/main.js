'use strict'

const DynamoTable = require('./services/dynamo');
const { uuid } = require('uuidv4');

const gamesTable = new DynamoTable(process.env.GAMES_TABLE)

exports.handler = async (event) => {
  try {
    console.debug('processing event', { context: event })

    const newGame = {
      gameId: uuid(),
      ...event
    }

    console.debug('Inserted game', newGame)

    await gamesTable.create(newGame)

    const response = {
      message: "Ok!"
    }
    return response

  } catch (error) {
    console.error(error)
    throw error
  }
}
