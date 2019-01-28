# frozen_string_literal: true

# Takes care of all graphql queries
class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    opts = { variables: variables,
             context: context,
             operation_name: operation_name }
    result = ReportFactorySchema.execute(query, opts)
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      format_to_hash(ambiguous_param)
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def format_to_hash(ambiguous_param)
    return {} unless ambiguous_param.present?

    ensure_hash(JSON.parse(ambiguous_param))
  end
end
