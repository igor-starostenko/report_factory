# frozen_string_literal: true

ScenarioDetailsType = GraphQL::ObjectType.define do
  name 'ScenarioDetails'
  description 'Test Scenario execution data'
  field :name, !types.String do
    resolve ->(obj, _args, _context) { obj.last.full_description }
  end
  field :project_name, !types.String do
    resolve lambda { |obj, _args, _context|
      obj.last.report.project.project_name
    }
  end
  field :last_status, !types.String do
    resolve ->(obj, _args, _context) { obj.last.status }
  end
  field :last_run, !types.String do
    resolve ->(obj, _args, _context) { obj.last.report.created_at }
  end
  field :last_passed, types.String do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.last_status(obj, 'passed')
    }
  end
  field :last_failed, types.String do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.last_status(obj, 'failed')
    }
  end
  field :total_runs, !types.Int do
    resolve ->(obj, _args, _context) { obj&.size || 0 }
  end
  field :total_passed, !types.Int do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.count_status(obj, 'passed')
    }
  end
  field :total_failed, !types.Int do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.count_status(obj, 'failed')
    }
  end
  field :total_pending, !types.Int do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.count_status(obj, 'pending')
    }
  end
end
