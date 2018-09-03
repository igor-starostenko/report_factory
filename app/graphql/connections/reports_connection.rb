# frozen_string_literal: true

ReportsConnection = RspecReportType.define_connection do
  name 'ReportsConnection'

  field :totalCount, !types.Int do
    resolve ->(obj, _args, _ctx) {
      obj.nodes.count
    }
  end
end

