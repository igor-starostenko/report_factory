# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, :user, type: :model do
  let :user do
    FactoryBot.create(:user,
                      name: 'Tester',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12',
                      type: 'Tester')
  end

  it 'is valid' do
    expect(user).to be_valid
  end

  it 'has :timestamps' do
    expect(user.created_at).to be_truthy
    expect(user.updated_at).to be_truthy
  end

  it 'is not valid without :name' do
    user.name = nil
    expect(user).to_not be_valid
  end

  it 'is not valid without :email' do
    user.email = nil
    expect(user).to_not be_valid
  end

  it 'is not valid without :name' do
    user.name = nil
    expect(user).to_not be_valid
  end

  it 'is not valid with :name < 3' do
    user.name = 'AB'
    expect(user).to_not be_valid
  end

  it 'is not valid with :name > 11' do
    user.name = '123456789012'
    expect(user).to_not be_valid
  end

  it 'is not valid without :type' do
    user.type = nil
    expect(user).to_not be_valid
  end

  it 'is not valid without :email' do
    user.email = nil
    expect(user).to_not be_valid
  end

  context 'email format' do
    it 'is not valid if :email doesn\'t have "@" symbol' do
      user.email = 'test.mailinator.com'
      expect(user).to_not be_valid
    end

    it 'is not valid if :email doesn\'t have a domain' do
      user.email = 'test@com'
      expect(user).to_not be_valid
    end

    it 'is not valid if :email doesn\'t have a top level domain' do
      user.email = 'test@mailinator'
      expect(user).to_not be_valid
    end

    it 'is not valid if :email doesn\'t have a name' do
      user.email = '@mailinator.com'
      expect(user).to_not be_valid
    end
  end

  it 'is not valid without :password' do
    user.password = nil
    expect(user).to_not be_valid
  end

  it 'has :api_key' do
    expect(user.api_key ).to be_truthy
  end
end
