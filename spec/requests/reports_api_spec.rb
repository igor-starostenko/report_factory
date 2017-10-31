# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', :reports_api, type: :request do
  before do
    project = FactoryBot.create(:project, project_name: 'Web App')
    rspec_report = FactoryBot.create(:rspec_report,
                                     version: '1.0.0',
                                     summary_line: '8 examples, 0 failures')
    FactoryBot.create(:report,
                      project_id: project.id,
                      reportable_type: RspecReport,
                      reportable_id: rspec_report.id)
  end

  describe 'GET index' do
    it 'gets all reports within a project' do
      get '/api/v1/projects/web_app/reports'
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('reports')
    end
  end
end
