export type Maybe<T> = T | null;

// ====================================================
// Types
// ====================================================

export interface Query {
  tasks: Task[];
}

export interface Task {
  id: string;

  title: string;

  completed: boolean;
}

export interface Mutation {
  createTask: Task;
}

// ====================================================
// Arguments
// ====================================================

export interface CreateTaskMutationArgs {
  title: string;
}

import { GraphQLResolveInfo } from "graphql";

export type Resolver<Result, Parent = {}, TContext = {}, Args = {}> = (
  parent: Parent,
  args: Args,
  context: TContext,
  info: GraphQLResolveInfo
) => Promise<Result> | Result;

export interface ISubscriptionResolverObject<Result, Parent, TContext, Args> {
  subscribe<R = Result, P = Parent>(
    parent: P,
    args: Args,
    context: TContext,
    info: GraphQLResolveInfo
  ): AsyncIterator<R | Result> | Promise<AsyncIterator<R | Result>>;
  resolve?<R = Result, P = Parent>(
    parent: P,
    args: Args,
    context: TContext,
    info: GraphQLResolveInfo
  ): R | Result | Promise<R | Result>;
}

export type SubscriptionResolver<
  Result,
  Parent = {},
  TContext = {},
  Args = {}
> =
  | ((
      ...args: any[]
    ) => ISubscriptionResolverObject<Result, Parent, TContext, Args>)
  | ISubscriptionResolverObject<Result, Parent, TContext, Args>;

export type TypeResolveFn<Types, Parent = {}, TContext = {}> = (
  parent: Parent,
  context: TContext,
  info: GraphQLResolveInfo
) => Maybe<Types>;

export type NextResolverFn<T> = () => Promise<T>;

export type DirectiveResolverFn<TResult, TArgs = {}, TContext = {}> = (
  next: NextResolverFn<TResult>,
  source: any,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => TResult | Promise<TResult>;

export namespace QueryResolvers {
  export interface Resolvers<TContext = {}, TypeParent = {}> {
    tasks?: TasksResolver<Task[], TypeParent, TContext>;
  }

  export type TasksResolver<R = Task[], Parent = {}, TContext = {}> = Resolver<
    R,
    Parent,
    TContext
  >;
}

export namespace TaskResolvers {
  export interface Resolvers<TContext = {}, TypeParent = Task> {
    id?: IdResolver<string, TypeParent, TContext>;

    title?: TitleResolver<string, TypeParent, TContext>;

    completed?: CompletedResolver<boolean, TypeParent, TContext>;
  }

  export type IdResolver<R = string, Parent = Task, TContext = {}> = Resolver<
    R,
    Parent,
    TContext
  >;
  export type TitleResolver<
    R = string,
    Parent = Task,
    TContext = {}
  > = Resolver<R, Parent, TContext>;
  export type CompletedResolver<
    R = boolean,
    Parent = Task,
    TContext = {}
  > = Resolver<R, Parent, TContext>;
}

export namespace MutationResolvers {
  export interface Resolvers<TContext = {}, TypeParent = {}> {
    createTask?: CreateTaskResolver<Task, TypeParent, TContext>;
  }

  export type CreateTaskResolver<
    R = Task,
    Parent = {},
    TContext = {}
  > = Resolver<R, Parent, TContext, CreateTaskArgs>;
  export interface CreateTaskArgs {
    title: string;
  }
}

/** Directs the executor to skip this field or fragment when the `if` argument is true. */
export type SkipDirectiveResolver<Result> = DirectiveResolverFn<
  Result,
  SkipDirectiveArgs,
  {}
>;
export interface SkipDirectiveArgs {
  /** Skipped when true. */
  if: boolean;
}

/** Directs the executor to include this field or fragment only when the `if` argument is true. */
export type IncludeDirectiveResolver<Result> = DirectiveResolverFn<
  Result,
  IncludeDirectiveArgs,
  {}
>;
export interface IncludeDirectiveArgs {
  /** Included when true. */
  if: boolean;
}

/** Marks an element of a GraphQL schema as no longer supported. */
export type DeprecatedDirectiveResolver<Result> = DirectiveResolverFn<
  Result,
  DeprecatedDirectiveArgs,
  {}
>;
export interface DeprecatedDirectiveArgs {
  /** Explains why this element was deprecated, usually also including a suggestion for how to access supported similar data. Formatted using the Markdown syntax (as specified by [CommonMark](https://commonmark.org/). */
  reason?: string;
}

export interface IResolvers<TContext = {}> {
  Query?: QueryResolvers.Resolvers<TContext>;
  Task?: TaskResolvers.Resolvers<TContext>;
  Mutation?: MutationResolvers.Resolvers<TContext>;
}

export interface IDirectiveResolvers<Result> {
  skip?: SkipDirectiveResolver<Result>;
  include?: IncludeDirectiveResolver<Result>;
  deprecated?: DeprecatedDirectiveResolver<Result>;
}
