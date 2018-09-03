# frozen_string_literal: true

# Add root-level fields here.
# They will be entry points for queries on your schema.
Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema'

  field :projects, !types[!ProjectType] do
    description 'All Projects'

    resolve lambda { |_obj, _args, _context|
      Project.all
    }
  end

  field :project, !ProjectType do
    description 'Find a Project by projectName'
    argument :project_name, !types.String

    resolve lambda { |_obj, args, _context|
      Project.by_name(args.project_name)
    }
  end

  connection :reportsConnection, !ReportsConnection do
    description 'Reports Pagination'

    resolve lambda { |_obj, _args, _context|
      Report.order(id: :desc)
    }
  end

  connection :rspecReportsConnection, !RspecReportsConnection do
    description 'Rspec Reports Pagination'
    argument :tags, types[types.String], default_value: nil

    resolve lambda { |_obj, args, _context|
      tags = args.tags&.map(&:downcase)
      rspec_reports = RspecReport.all_details
      tags ? rspec_reports.tags(tags) : rspec_reports
    }
  end

  field :scenarios, !types[!ScenarioType] do
    description 'All Scenarios'

    resolve lambda { |_obj, _args, _context|
      RspecExample.scenarios
    }
  end

  field :scenario, !ScenarioDetailsType do
    description 'Statistics of all Scenario runs'

    argument :scenario_name, !types.String
    argument :project_name, !types.String

    resolve lambda { |_obj, args, _context|
      Project.by_name(args.project_name)
             .rspec_examples
             .where(full_description: args.scenario_name)
    }
  end
end
