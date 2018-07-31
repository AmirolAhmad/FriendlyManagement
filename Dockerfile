FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /FriendManagement
WORKDIR /FriendManagement
COPY Gemfile /FriendManagement/Gemfile
COPY Gemfile.lock /FriendManagement/Gemfile.lock
RUN bundle install
COPY . /FriendManagement
