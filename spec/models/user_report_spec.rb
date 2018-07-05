# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserReport, :user_report, type: :model do
  before do
    FactoryBot.create(:tester,
                      name: 'Tester',
                      email: 'tester@mailinator.com',
                      password: 'Qwerty12')
    FactoryBot.create(:project, project_name: 'Web App')
    FactoryBot.create(:rspec_report,
                      version: '1.0.0',
                      summary_line: '8 examples, 0 failures')
    FactoryBot.create(:report,
                      project_id: Project.last.id,
                      reportable_type: RspecReport,
                      reportable_id: RspecReport.last.id,
                      status: 'passed')
  end

  let(:user_report) do
    FactoryBot.create(:user_report,
                      user_id: User.last.id,
                      report_id: Report.last.id)
  end

  it 'is valid' do
    expect(user_report).to be_valid
  end

  it 'belongs to user' do
    expect(user_report.user.name).to eql('Tester')
  end

  it 'belongs to report' do
    expect(user_report.report.reportable_type).to eql('RspecReport')
  end

  it 'has RSpec scope' do
    user_report.save
    expect(described_class.rspec.size).to be_positive
  end
end
