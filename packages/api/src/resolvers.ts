import { IResolvers, QueryResolvers, MutationResolvers } from './generated/graphql';
import uuid from "uuid"

const queryResolvers: QueryResolvers.Resolvers = {
    tasks: () => [
      { id: "1", title: "fix roof", completed: false},
      { id: "2", title: "buy chocoloate", completed: false},
      { id: "3", title: "new shoes", completed: false}
    ]
}

const mutationResolvers: MutationResolvers.Resolvers = {
  createTask: (_, { title }) => {
    return { id: uuid.v4(), title, completed: false }
  }
}

export const resolvers: IResolvers = {
  Query: queryResolvers,
  Mutation: mutationResolvers
} 