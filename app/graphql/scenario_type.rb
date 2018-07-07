ScenarioType = GraphQL::ObjectType.define do
  name 'Scenario'
  description 'Test Scenario'
  field :spec_id, !types.String do
    resolve -> (obj, args, ctx) { obj.spec_id }
  end
  field :description, !types.String do
    resolve -> (obj, args, ctx) { obj.description }
  end
  field :full_description, !types.String do
    resolve -> (obj, args, ctx) { obj.full_description }
  end
  field :name, !types.String do
    resolve -> (obj, args, ctx) { obj.full_description }
  end
  field :status, !types.String do
    resolve -> (obj, args, ctx) { obj.status }
  end
  field :last_status, !types.String do
    resolve -> (obj, args, ctx) { obj.status }
  end
  field :line_number, !types.String do
    resolve -> (obj, args, ctx) { obj.line_number }
  end
  # field :last_run, !types.String do
  #   resolve -> (obj, args, ctx) { examples.last.report.created_at }
  # end
  # field :last_passed, !types.String do
  #   resolve -> (obj, args, ctx) { last_status(examples, 'passed') }
  # end
  # field :last_failed, !types.String do 
  #   resolve -> (obj, args, ctx) { last_status(examples, 'failed') }
  # end
  # field :total_runs, !types.String do
  #   resolve -> (obj, args, ctx) { examples&.size || 0 }
  # end
  # field :total_passed, !types.String do
  #   resolve -> (obj, args, ctx) { count_status(examples, 'passed') }
  # end
  # field :total_failed, !types.String do
  #   resolve -> (obj, args, ctx) { count_status(examples, 'failed') }
  # end
  # field :total_pending, !types.String do
  #   resolve -> (obj, args, ctx) { count_status(examples, 'pending') }
  # end
end
