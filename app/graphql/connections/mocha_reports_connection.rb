# frozen_string_literal: true

MochaReportsConnection = MochaReportType.define_connection do
  name 'MochaReportsConnection'

  field :totalCount, !types.Int do
    resolve lambda { |obj, _args, _ctx|
      obj.nodes.count
    }
  end
end
