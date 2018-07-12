# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  # field :renameProject, field: Mutations::RenameProject.field
end
