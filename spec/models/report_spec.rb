# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, :report, type: :model do
  let :project do
    FactoryBot.create(:project, project_name: 'Web App')
  end
  let :rspec_report do
    FactoryBot.create(:rspec_report,
                      version: '1.0.0',
                      summary_line: '8 examples, 0 failures')
  end
  let :report do
    FactoryBot.create(:report,
                      project_id: project.id,
                      reportable_type: RspecReport,
                      reportable_id: rspec_report.id,
                      status: 'passed')
  end

  it 'is valid' do
    expect(report).to be_valid
  end

  it 'has :timestamps' do
    expect(report.created_at).to be_truthy
    expect(report.updated_at).to be_truthy
  end

  it 'is not valid without :project_id' do
    report.project_id = nil
    expect(report).to_not be_valid
  end

  it 'is not valid without :reportable_type' do
    report.reportable_type = nil
    expect(report).to_not be_valid
  end

  it 'is not valid without :reportable_id' do
    report.reportable_id = nil
    expect(report).to_not be_valid
  end

  it 'is not valid without :status' do
    report.status = nil
    expect(report).to_not be_valid
  end

  it 'can have tags' do
    report.tags = %w[High Regression]
    expect(report).to be_valid
  end

  it 'can by filtered by tags' do
    relation = described_class.tags('High')
    expect(relation.class.to_s).to eql('Report::ActiveRecord_Relation')
  end

  it 'belongs to one :project' do
    expect(report.project).to be_instance_of(Project)
    expect(report.project.id).to eq(project.id)
  end

  it 'can have one :rspec_report' do
    expect(report.reportable).to be_instance_of(RspecReport)
    expect(report.reportable.id).to eq(rspec_report.id)
  end
end
