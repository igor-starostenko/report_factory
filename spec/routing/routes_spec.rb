require 'rails_helper'

RSpec.describe 'routing', :routing, type: :routing do
  context '/api/v1' do
    it 'does not expose /api' do
      expect(get: '/api').not_to be_routable
    end

    it 'does not expost /api/v1' do
      expect(get: '/api/v1').not_to be_routable
    end
  end

  context '/projects', :projects do
    it 'routes GET /api/v1/projects to projects#index' do
      expect(get: '/api/v1/projects').to route_to(
        controller: 'projects',
        action: 'index'
      )
    end

    it 'routes POST /api/v1/projects to projects#create' do
      expect(post: '/api/v1/projects').to route_to(
        controller: 'projects',
        action: 'create'
      )
    end

    it 'routes GET /api/v1/projects/:project_name to projects#show' do
      expect(get: '/api/v1/projects/web_project').to route_to(
        controller: 'projects',
        action: 'show',
        project_name: 'web_project'
      )
    end

    it 'routes PUT /api/v1/projects/:project_name to projects#update' do
      expect(put: '/api/v1/projects/web_project').to route_to(
        controller: 'projects',
        action: 'update',
        project_name: 'web_project'
      )
    end

    context '/reports', :reports do
      it 'routes GET /api/v1/projects/:project_name/reports to reports#index' do
        expect(get: '/api/v1/projects/web_project/reports').to route_to(
          controller: 'reports',
          action: 'index',
          project_name: 'web_project'
        )
      end

      context '/rspec', :rspec_reports do
        it 'routes GET /api/v1/projects/:project_name/reports/rspec to reports#index' do
          expect(get: '/api/v1/projects/web_project/reports/rspec').to route_to(
            controller: 'rspec_reports',
            action: 'index',
            project_name: 'web_project'
          )
        end

        it 'routes POST /api/v1/projects/:project_name/reports/rspec to reports#create' do
          expect(post: '/api/v1/projects/web_project/reports/rspec').to route_to(
            controller: 'rspec_reports',
            action: 'create',
            project_name: 'web_project'
          )
        end

        it 'routes GET /api/v1/projects/:project_name/reports/:id to reports#show' do
          expect(get: '/api/v1/projects/web_project/reports/rspec/1').to route_to(
            controller: 'rspec_reports',
            action: 'show',
            project_name: 'web_project',
            id: '1'
          )
        end
      end
    end
  end
end
