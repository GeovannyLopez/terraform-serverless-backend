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
    return lambda_response(200, response)

  } catch (error) {
    console.error(error)
    throw error
  }
}

async function lambda_response(status, body) {
  return {
    statusCode: status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify(body)
  }
}
