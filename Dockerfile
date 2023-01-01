FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y postgresql-client
RUN gem install bundler:2.3.26
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]