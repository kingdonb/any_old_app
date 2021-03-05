FROM ruby:2.7.2
# RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /any_old_app
COPY Gemfile /any_old_app/Gemfile
COPY Gemfile.lock /any_old_app/Gemfile.lock
RUN bundle install
COPY . /any_old_app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
