import { ApolloServer } from "apollo-server-lambda"
import schema from "./schema.graphql"
import  { resolvers } from "./resolvers"
import { IResolvers } from './generated/graphql';

interface StringIndexSignatureInterface {
  [index: string]: any
}

type StringIndexed<T> = T & StringIndexSignatureInterface

// Type fixed https://github.com/dotansimha/graphql-code-generator/issues/1133
const res: StringIndexed<IResolvers> = resolvers

const server = new ApolloServer({
  typeDefs: schema,
  resolvers: res,
  formatError: error => {
    console.log(error)
    return error
  },
  formatResponse: (response: string) => {
    console.log(response)
    return response
  },
  context: ({ event, context }) => ({
    headers: event.headers,
    functionName: context.functionName,
    event,
    context
  }),
  playground: {
    endpoint: process.env.REACT_APP_GRAPHQL_ENDPOINT
      ? process.env.REACT_APP_GRAPHQL_ENDPOINT
      : "/production/graphql"
  },
  tracing: true
})

export const graphql = server.createHandler({
  cors: {
    origin: "*"
  }
})
