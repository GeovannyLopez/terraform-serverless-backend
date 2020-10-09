const AWS = require('aws-sdk')

const dynamodb = new AWS.DynamoDB.DocumentClient()

class dynamoTable {
  constructor (tableName) {
    this.tableName = tableName
  }

  create = async (document, additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      Item: document,
      ...additionalParams
    }

    return dynamodb.put(params).promise()
  }

  get = async (key, additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      Key: key,
      ...additionalParams
    }

    return dynamodb.get(params).promise()
  }

  delete = async (key, additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      Key: key,
      ...additionalParams
    }

    return dynamodb.delete(params).promise()
  }

  update = async (key, document, additionalParams = {}) => {
    const expressionAttributeValues = {}
    const expressionAttributeNames = {}
    const updateExpressions = []

    for (const property in document) {
      expressionAttributeNames[`#${property}`] = property
      expressionAttributeValues[`:${property}`] = document[property]
      updateExpressions.push(`#${property} = :${property}`)
    }

    const params = {
      TableName: this.tableName,
      Key: key,
      UpdateExpression: 'set ' + updateExpressions.join(', '),
      ExpressionAttributeNames: expressionAttributeNames,
      ExpressionAttributeValues: expressionAttributeValues,
      ...additionalParams
    }

    return dynamodb.update(params).promise()
  }

  delete = async (key) => {
    const params = {
      TableName: this.tableName,
      Key: key
    }

    return dynamodb.delete(params).promise()
  }

  call = (action, params) => {
    return dynamodb[action]({
      ...params,
      TableName: this.tableName
    }).promise()
  }

  scan = async (additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      ...additionalParams
    }

    const items = []
    let continueFlag = false
    do {
      const result = await dynamodb.scan(params).promise()
      items.push(...result.Items)

      // continue scanning if we have more movies, because
      // scan can retrieve a maximum of 1MB of data
      if (typeof result.LastEvaluatedKey !== 'undefined') {
        console.info('Scanning for results...')
        params.ExclusiveStartKey = result.LastEvaluatedKey

        continueFlag = true
      } else {
        continueFlag = false
      }
    } while (continueFlag)

    return items
  }

  query = async (additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      ...additionalParams
    }

    return dynamodb.query(params).promise()
  }
}

module.exports = dynamoTable
