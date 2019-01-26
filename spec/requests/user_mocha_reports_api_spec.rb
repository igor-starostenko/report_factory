# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserMochaReports', :user_mocha_reports_api, type: :request do
  before do
    user = FactoryBot.create(:tester,
                             name: 'MochaTester',
                             email: 'user_mocha_reports@mailinator.com',
                             password: 'Qwerty12')
    project = FactoryBot.create(:project, project_name: 'Web App')
    mocha_report = FactoryBot.create(:mocha_report,
                                     suites: 2,
                                     total: 2,
                                     passes: 1,
                                     pending: 0,
                                     failures: 1,
                                     duration: 8,
                                     started: '2019-01-20T04:28:34.861Z',
                                     ended: '2019-01-20T04:28:34.867Z')
    report = FactoryBot.create(:report,
                               project_id: project.id,
                               reportable_type: MochaReport,
                               reportable_id: mocha_report.id,
                               status: 'failed')
    FactoryBot.create(:user_report,
                      user_id: user.id,
                      report_id: report.id)
  end
  let(:user) { User.find_by(name: 'MochaTester') }
  let(:report) { Report.first }
  let(:mocha_report) { MochaReport.first }

  describe 'GET index' do
    it 'is not authorized without X-API-KEY' do
      get "/api/v1/users/#{user.id}/reports/mocha"
      expect(response.status).to eq(401)
    end

    before do
      get "/api/v1/users/#{user.id}/reports/mocha", headers: {
        'X-API-KEY' => user.api_key
      }
    end
    let(:body) { JSON.parse(response.body).fetch('data') }

    it 'doesn\'t expose X-API-KEY' do
      api_key = body.sample.dig('attributes', 'api_key')
      expect(api_key).to be_nil
    end

    it 'gets all reports of the requested user' do
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('user_report')

      json_body = JSON.parse(response.body)
      duration = json_body.fetch('data').first
                          .dig('attributes', 'report', 'duration')
      expect(duration).to eql(mocha_report.duration)
    end
  end
end
