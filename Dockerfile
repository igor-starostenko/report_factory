# Use the latest and greatest version of Ruby 2.5.0.
FROM ruby:2.5.0-alpine

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Igor Starostenko <contact.igorstar@gmail.com>

# Install dependencies:
RUN apk update && apk add build-base tzdata nodejs postgresql-dev

# This sets the context of where commands will be ran.
RUN mkdir /app
WORKDIR /app

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs --without development test

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . /app

ENTRYPOINT ["puma", "-C", "config/puma.rb"]
