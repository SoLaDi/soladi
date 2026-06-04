FROM ruby:3.3.6

RUN addgroup --gid 1000 user
RUN adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

WORKDIR /app

COPY . .

ARG RAILS_ENV=production
ARG SECRET_KEY_BASE=some-secret

RUN gem install bundler
RUN bundle config set without 'development test'
RUN bundle install
RUN yarn install
RUN rails assets:precompile

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-e", "production", "-b", "0.0.0.0"]
