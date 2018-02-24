# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routing', :routing, type: :routing do
  context '/api/v1' do
    it 'does not expose /api' do
      expect(get: '/api').not_to be_routable
    end

    it 'does not expose /api/v1' do
      expect(get: '/api/v1').not_to be_routable
    end
  end

  it 'routes GET /api/v1/user to users#auth' do
    expect(get: '/api/v1/user').to route_to(
      controller: 'users',
      action: 'auth'
    )
  end

  context '/api/v1/users', :users do
    it 'routes GET /api/v1/users to users#index' do
      expect(get: '/api/v1/users').to route_to(
        controller: 'users',
        action: 'index'
      )
    end

    it 'routes POST /api/v1/users/login to users#login' do
      expect(post: '/api/v1/users/login').to route_to(
        controller: 'users',
        action: 'login'
      )
    end

    it 'routes POST /api/v1/users/create to users#create' do
      expect(post: '/api/v1/users/create').to route_to(
        controller: 'users',
        action: 'create'
      )
    end

    it 'routes PUT /api/v1/users/:id to users#update' do
      expect(put: '/api/v1/users/1').to route_to(
        controller: 'users',
        action: 'update',
        id: '1'
      )
    end

    it 'routes GET /api/v1/users/:id to users#show' do
      expect(get: '/api/v1/users/1').to route_to(
        controller: 'users',
        action: 'show',
        id: '1'
      )
    end

    it 'routes DELETE /api/v1/users/:id to users#destroy' do
      expect(delete: '/api/v1/users/1').to route_to(
        controller: 'users',
        action: 'destroy',
        id: '1'
      )
    end

    it 'routes GET /api/v1/users/:id to user_reports#index' do
      expect(get: '/api/v1/users/1/reports').to route_to(
        controller: 'user_reports',
        action: 'index',
        id: '1'
      )
    end
  end

  context '/api/v1/projects', :projects do
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

    it 'routes DELETE /api/v1/projects/:project_name to projects#destroy' do
      expect(delete: '/api/v1/projects/web_project').to route_to(
        controller: 'projects',
        action: 'destroy',
        project_name: 'web_project'
      )
    end
  end

  context '/api/v1/projects/:project_name/reports', :project_reports do
    it 'routes GET /api/v1/projects/:project_name/reports to reports#index' do
      expect(get: '/api/v1/projects/web_project/reports').to route_to(
        controller: 'project_reports',
        action: 'index',
        project_name: 'web_project'
      )
    end
  end

  context '/api/v1/projects/:project_name/reports/rspec', :rspec_reports do
    it 'routes GET /api/v1/projects/:project_name/reports/rspec'\
      'to rspec_reports#index' do
      expect(get: '/api/v1/projects/web_project/reports/rspec').to route_to(
        controller: 'project_rspec_reports',
        action: 'index',
        project_name: 'web_project'
      )
    end

    it 'routes POST /api/v1/projects/:project_name/reports/rspec'\
      'to reports#create' do
      expect(post: '/api/v1/projects/web_project/reports/rspec').to route_to(
        controller: 'project_rspec_reports',
        action: 'create',
        project_name: 'web_project'
      )
    end

    it 'routes GET /api/v1/projects/:project_name/reports/:id'\
      'to reports#show' do
      expect(get: '/api/v1/projects/web_project/reports/rspec/1').to route_to(
        controller: 'project_rspec_reports',
        action: 'show',
        project_name: 'web_project',
        id: '1'
      )
    end
  end

  context '/api/v1/reports', :reports do
    it 'routes GET /api/v1/reports'\
      'to reports#index' do
      expect(get: '/api/v1/reports').to route_to(
        controller: 'reports',
        action: 'index'
      )
    end

    it 'routes GET /api/v1/reports/:id'\
      'to reports#show' do
      expect(get: '/api/v1/reports/1').to route_to(
        controller: 'reports',
        action: 'show',
        id: '1'
      )
    end
  end
end
