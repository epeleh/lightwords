FROM ruby:2.7.1

WORKDIR /data
COPY . .

ENV RAILS_ENV production
ARG RAILS_SERVE_STATIC_FILES
ARG RAILS_MASTER_KEY
ARG SECRET_KEY_BASE
EXPOSE 3000

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update -y && apt-get install -y yarn

RUN bundle install && bundle exec rails assets:precompile
CMD (bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup) && bundle exec rails server
