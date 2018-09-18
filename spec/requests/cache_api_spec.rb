# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Application', :application, type: :request do
  before do
    FactoryBot.create(:tester,
                      name: 'user',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
    project = FactoryBot.create(:project, project_name: 'Web-App')
    rspec_report = FactoryBot.create(:rspec_report,
                                     version: '1.0.0',
                                     summary_line: '8 examples, 0 failures')
    FactoryBot.create(:report,
                      project_id: project.id,
                      reportable_type: RspecReport,
                      reportable_id: rspec_report.id,
                      status: 'passed')
  end
  let(:tester) { Tester.first }

  context 'cache', :cache do
    describe 'GET cache_evict' do
      let(:cache_key) { 'test_cache' }

      before do
        Rails.cache.write(cache_key, message: 'Test')
      end

      it 'clears cache' do
        get '/api/v1/cache/clear'
        expect(response.status).to eq(200)
        cache = Rails.cache.read(cache_key)
        expect(cache).to eql(nil)
      end
    end
  end
end
