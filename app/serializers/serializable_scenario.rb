# frozen_string_literal: true

# Formats Project Scenario JSON API
class SerializableScenario < JSONAPI::Serializable::Resource
  type 'scenarios'

  @object
end
