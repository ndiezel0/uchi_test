FROM ruby:2.5

RUN gem install bundler -v '>= 2'

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN apt-get update && apt-get install nodejs -y

COPY . .

CMD rails s -b 0.0.0.0 -p $PORT