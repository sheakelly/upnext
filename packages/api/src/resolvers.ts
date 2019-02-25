import { IResolvers, QueryResolvers } from './generated/graphql';

const queryResolvers: QueryResolvers.Resolvers = {
    tasks: () => [
      { id: "1", title: "fix roof", completed: false},
      { id: "2", title: "buy chocoloate", completed: false},
      { id: "3", title: "new shoes", completed: false}
    ]
}

export const resolvers: IResolvers = {
  Query: queryResolvers
} 