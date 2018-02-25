# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Api Pagination configuration.
# Read more: https://github.com/davidcelis/api-pagination

ApiPagination.configure do |config|
  # If you have both gems included, you can choose a paginator.
  config.paginator = :will_paginate # or :kaminari

  # By default, this is set to 'Total'
  config.total_header = 'Total'

  # By default, this is set to 'Per-Page'
  config.per_page_header = 'Per-Page'

  # Optional: set this to add a header with the current page number.
  config.page_header = 'Page'
end
