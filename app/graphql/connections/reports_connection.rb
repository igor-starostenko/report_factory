# frozen_string_literal: true

ReportsConnection = ReportType.define_connection do
  name 'ReportsConnection'

  field :totalCount, !types.Int do
    resolve lambda { |obj, _args, _ctx|
      obj.nodes.count
    }
  end
end
