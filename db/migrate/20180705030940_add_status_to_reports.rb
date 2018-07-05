class AddStatusToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :status, :string
    reports = Report.where(reportable_type: 'RspecReport')
                    # .includes({ reportable: { examples: :exception }})
    reports.each do |report|
      is_failed = report.reportable.examples.any?(&:failed?)
      report.status = is_failed ? 'failed' : 'passed'
      report.save
    end
  end
end
