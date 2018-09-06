# frozen_string_literal: true

ScenarioDetailsType = GraphQL::ObjectType.define do
  name 'ScenarioDetails'
  description 'Test Scenario execution data'
  field :name, !types.String do
    resolve ->(obj, _args, _context) { obj.last.full_description }
  end
  field :projectName, !types.String do
    resolve lambda { |obj, _args, _context|
      obj.last.report.project.project_name
    }
  end
  field :lastStatus, !types.String do
    resolve ->(obj, _args, _context) { obj.last.status }
  end
  field :lastRun, !types.String do
    resolve ->(obj, _args, _context) { obj.last.report.created_at }
  end
  field :lastPassed, types.String do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.last_status(obj, 'passed')
    }
  end
  field :lastFailed, types.String do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.last_status(obj, 'failed')
    }
  end
  field :totalRuns, !types.Int do
    resolve ->(obj, _args, _context) { obj&.size || 0 }
  end
  field :totalPassed, !types.Int do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.count_status(obj, 'passed')
    }
  end
  field :totalFailed, !types.Int do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.count_status(obj, 'failed')
    }
  end
  field :totalPending, !types.Int do
    resolve lambda { |obj, _args, _context|
      ScenarioSerializers.count_status(obj, 'pending')
    }
  end
end
