# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', :users_api, type: :request do
  before do
    FactoryBot.create(:tester,
                      name: 'user',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
    FactoryBot.create(:admin,
                      name: 'Admin Man',
                      email: 'admin@mailinator.com',
                      password: 'AdminPass1')
  end
  let(:tester) { Tester.first }
  let(:admin) { Admin.first }

  describe 'GET index' do
    it 'is not authorized without X-API-KEY' do
      get '/api/v1/users'
      expect(response.status).to eq(401)
    end

    before do
      get '/api/v1/users', headers: {
        'X-API-KEY' => tester.api_key
      }
    end

    it 'doesn\'t expose X-API-KEY' do
      api_key = body.sample.dig('attributes', 'api_key')
      expect(api_key).to be_nil
    end

    let(:body) { JSON.parse(response.body).fetch('data') }

    it 'gets all registered users' do
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('user')
    end
  end

  describe 'POST login' do
    it 'is not authorized without valid credentials' do
      post '/api/v1/users/login', params: {
        data: {
          type: 'user',
          attributes: {
            email: 'test@mailinator.com',
            password: 'Qwerty11'
          }
        }
      }
      expect(response.status).to eq(401)
    end

    before do
      post '/api/v1/users/login', params: {
        data: {
          type: 'user',
          attributes: {
            email: 'test@mailinator.com',
            password: 'Qwerty12'
          }
        }
      }
    end

    it 'shows user' do
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('user')
    end

    it 'returns user\'s  X-API-KEY' do
      api_key = response.headers['X-API-KEY']
      expect(api_key).to eql(tester.api_key)
    end
  end

  describe 'POST create' do
    it 'is not authorized without X-API-KEY' do
      post '/api/v1/users/create', params: {
        data: {
          type: 'user',
          attributes: {
            name: 'New User',
            email: 'new_user@mailinator.com',
            password: 'Password1'
          }
        }
      }
      expect(response.status).to eq(401)
    end

    it 'is not authorized to be performed by Tester' do
      post '/api/v1/users/create', headers: {
        'X-API-KEY' => tester.api_key
      }, params: {
        data: {
          type: 'user',
          attributes: {
            name: 'New User',
            email: 'new_user@mailinator.com',
            password: 'Password1'
          }
        }
      }
      expect(response.status).to eq(401)
    end

    it 'creates a user' do
      post '/api/v1/users/create', headers: {
        'X-API-KEY' => admin.api_key
      }, params: {
        data: {
          type: 'user',
          attributes: {
            name: 'New User',
            email: 'new_user@mailinator.com',
            password: 'Password1'
          }
        }
      }
      expect(response.status).to eq(201)
      expect(response.body).to be_json_response_for('user')
    end
  end

  describe 'GET show' do
    it 'is not authorized without X-API-KEY' do
      get '/api/v1/users/1'
      expect(response.status).to eq(401)
    end

    it 'is not authorized to be performed by others' do
      get '/api/v1/users/1', headers: {
        'X-API-KEY' => admin.api_key
      }
      expect(response.status).to eq(401)
    end

    before do
      get '/api/v1/users/1', headers: {
        'X-API-KEY' => tester.api_key
      }
    end
    let(:body) { JSON.parse(response.body).fetch('data') }

    it 'returns user\'s  X-API-KEY' do
      api_key = body.dig('attributes', 'api_key')
      expect(api_key).to eql(tester.api_key)
    end

    it 'shows a user' do
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('user')
    end
  end

  describe 'PUT update' do
    it 'is not authorized without X-API-KEY' do
      put '/api/v1/users/1', params: {
        data: {
          type: 'user',
          attributes: {
            name: 'New Name',
            email: 'new_email@mailinator.com',
            password: 'Password1'
          }
        }
      }
      expect(response.status).to eq(401)
    end

    it 'is not authorized to be performed by Tester' do
      put '/api/v1/users/1', headers: {
        'X-API-KEY' => tester.api_key
      }, params: {
        data: {
          type: 'user',
          attributes: {
            name: 'New Name',
            email: 'new_email@mailinator.com',
            password: 'Password1'
          }
        }
      }
      expect(response.status).to eq(401)
    end

    it 'updates a user' do
      put '/api/v1/users/1', headers: {
        'X-API-KEY' => admin.api_key
      }, params: {
        data: {
          type: 'user',
          attributes: {
            name: 'New Name',
            email: 'new_email@mailinator.com',
            password: 'Password1',
            type: 'Admin'
          }
        }
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('user')
    end
  end

  describe 'DELETE destroy' do
    let(:other) do
      FactoryBot.create(:tester,
                        name: 'OtherTester',
                        email: 'other_test@mailinator.com',
                        password: 'Password1')
    end

    it 'is not authorized without X-API-KEY' do
      delete '/api/v1/users/1'
      expect(response.status).to eq(401)
    end

    it 'is not authorized to be performed by Tester' do
      delete '/api/v1/users/1', headers: {
        'X-API-KEY' => other.api_key
      }
      expect(response.status).to eq(401)
    end

    it 'deletes a user' do
      delete '/api/v1/users/1', headers: {
        'X-API-KEY' => admin.api_key
      }
      expect(response.status).to eq(200)
    end
  end
end
