FROM ruby:2.7.2
# RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /any_old_app
RUN useradd -u 1000 -Um rails && \
    chown -R rails:rails /any_old_app
USER 1000
COPY --chown=1000 Gemfile /any_old_app/Gemfile
COPY --chown=1000 Gemfile.lock /any_old_app/Gemfile.lock
RUN bundle install
COPY --chown=1000 . /any_old_app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
USER root
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

USER rails
# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
