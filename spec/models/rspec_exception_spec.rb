# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RspecExample, :rspec_example, type: :model do
  let :rspec_report do
    FactoryBot.create(:rspec_report,
                      version: '1.0.0',
                      summary_line: '8 examples, 0 failures')
  end
  let :rspec_example do
    FactoryBot.create(:rspec_example,
                      rspec_report_id: rspec_report.id,
                      status: 'passed')
  end
  let :exception_class { 'RSpec::Expectations::ExpectationNotMetError' }
  let :exception_message do
    '\nexpected: 200\n     got: 204\n\n(compared using ==)\n'
  end
  let :exception_backtrace do
    ['/support.rb:97', '/support.rb:106', '/fail_with.rb:35']
  end
  let :rspec_exception do
    FactoryBot.create(:rspec_exception,
                      rspec_example_id: rspec_example.id,
                      classname: exception_class,
                      message: exception_message,
                      backtrace: exception_backtrace)
  end

  it 'is valid' do
    expect(rspec_exception).to be_valid
  end

  it 'is not valid without :rspec_report_id' do
    rspec_exception.rspec_example_id = nil
    expect(rspec_exception).to_not be_valid
  end

  it 'is valid without :message' do
    rspec_exception.message = nil
    expect(rspec_exception).to be_valid
  end

  it 'is valid without :backtrace' do
    rspec_exception.backtrace = nil
    expect(rspec_exception).to be_valid
  end

  it 'is not valid without :classname' do
    rspec_exception.classname = nil
    expect(rspec_exception).to_not be_valid
  end

  it 'belongs to one :rspec_example' do
    expect(rspec_exception.rspec_example).to be_instance_of(RspecExample)
    expect(rspec_exception.rspec_example.id).to eq(rspec_example.id)
  end
end
