'use strict'

const DynamoTable = require('./services/dynamo');
const { uuid } = require('uuidv4');

const gamesTable = new DynamoTable(process.env.GAMES_TABLE)

exports.handler = async (event, context, callback) => {
  try {
    console.debug('processing event', { context: event })

    const request = JSON.parse(event.body)
    const newGame = {
      gameId: uuid(),
      ...request
    }

    console.debug('Inserted game', newGame)

    await gamesTable.create(newGame)

    const body = {
      message: "Created"
    }

    const response = {
      "statusCode": 200,
      "headers": {},
      "body": JSON.stringify(body),
      "isBase64Encoded": false
    };

    callback(null, response);

  } catch (error) {
    console.error(error)
    throw error
  }
}
