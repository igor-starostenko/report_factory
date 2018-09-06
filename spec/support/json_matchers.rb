# frozen_string_literal: true

RSpec::Matchers.define :be_json_response_for do |model|
  match do |actual|
    parsed_actual = JSON.parse(actual).fetch('data')
    if parsed_actual.is_a?(Array)
      expect(parsed_actual.size).to be_positive
      parsed_actual.each do |object|
        expect(object).to have_json_api_format(model)
      end
    else
      expect(parsed_actual).to have_json_api_format(model)
    end
  end
end

RSpec::Matchers.define :have_json_api_format do |model|
  match do |actual|
    actual['type'] == model && actual['attributes'].is_a?(Hash)
  end
end

RSpec::Matchers.define :match_json_object do |hash|
  match do |actual|
    hash.with_indifferent_access.each do |attribute, value|
      parsed_actual = actual.fetch(attribute)
      expect(parsed_actual).to eq(value)
    end
  end
end
