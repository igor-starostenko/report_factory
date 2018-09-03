# frozen_string_literal: true

RspecReportsConnection = RspecReportType.define_connection do
  name 'RspecReportsConnection'

  field :totalCount, !types.Int do
    resolve lambda { |obj, _args, _ctx|
      obj.nodes.count
    }
  end
end
