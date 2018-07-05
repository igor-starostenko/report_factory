# Add root-level fields here.
# They will be entry points for queries on your schema.
Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema'

  # project field signature
  field :project, !ProjectType do
    description 'Find a Project by projectName'
    argument :project_name, !types.String

    resolve -> (obj, args, context) {
      Project.by_name(args.project_name)
    }
  end

  # projects field signature
  field :projects, !types[!ProjectType] do
    description 'All Projects'

    resolve -> (obj, args, context) {
      Project.all
    }
  end
end
