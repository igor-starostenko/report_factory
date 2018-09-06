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
    argument :projectName, !types.String

    resolve lambda { |_obj, args, _context|
      Project.by_name(args.project_name)
    }
  end

  connection :reportsConnection, !ReportsConnection do
    description 'Reports Pagination'
    argument :tags, types[types.String], default_value: nil

    resolve lambda { |_obj, args, _context|
      tags = args.tags&.map(&:downcase)
      reports = Report.order(id: :desc)
      tags.blank? ? reports : reports.tags(tags)
    }
  end

  connection :rspecReportsConnection, !RspecReportsConnection do
    description 'Rspec Reports Pagination'
    argument :projectName, types.String, default_value: nil
    argument :tags, types[types.String], default_value: nil

    resolve lambda { |_obj, args, _context|
      project_name = args.projectName
      tags = args.tags&.map(&:downcase)
      rspec_reports = RspecReport.with_summary
      rspec_reports = rspec_reports.by_project(project_name) if project_name
      tags.blank? ? rspec_reports : rspec_reports.tags(tags)
    }
  end

  field :scenarios, !types[!ScenarioType] do
    description 'All Scenarios'

    resolve lambda { |_obj, _args, _context|
      RspecExample.cached_scenarios
    }
  end

  field :scenario, !ScenarioDetailsType do
    description 'Statistics of all Scenario runs'

    argument :scenarioName, !types.String
    argument :projectName, !types.String

    resolve lambda { |_obj, args, _context|
      Project.by_name(args.project_name)
             .rspec_examples
             .where(full_description: args.scenario_name)
    }
  end

  field :users, !types[!UserType] do
    description 'All Users'

    resolve lambda { |_obj, _args, _context|
      User.all
    }
  end

  field :user, !UserType do
    description 'User'
    argument :id, !types.Int

    resolve lambda { |_obj, args, _context|
      User.find(args.id)
    }
  end
end
