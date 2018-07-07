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

  field :scenarios, !types[!ScenarioType] do
    description 'All Scenarios'

    resolve -> (obj, args, context) {
      RspecExample.scenarios
    }
  end

  field :scenario, !ScenarioDetailsType do
    description 'Statistics of all Scenario runs'

    argument :scenario_name, !types.String
    argument :project_name, !types.String

    resolve -> (obj, args, context) {
      # RspecExample.where(full_description: args.scenario_name)
      Project.by_name(args.project_name)
             .rspec_examples
             .where(full_description: args.scenario_name)
    }
  end
end
