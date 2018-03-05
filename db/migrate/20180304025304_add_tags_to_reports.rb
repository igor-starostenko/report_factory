class AddTagsToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :tags, :text, array:true, default: []
    Report.all.each do |report|
      report.update_attributes!(tags: [])
    end
  end
end
