#  syntax = docker/dockerfile:1

FROM ruby:3.2.2

# Set environment variables for Rails
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs default-libmysqlclient-dev yarn 

# Set up the application directory
RUN mkdir /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock /app/

# Install the application dependencies
RUN gem install bundler && \
    bundle install --jobs 20 --retry 5

# Copy the Rails application code into the image
COPY . /app/

# Expose port 3000 to the outside world
EXPOSE 3000

