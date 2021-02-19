FROM ruby:2.7.2

RUN addgroup --gid 1000 user
RUN adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

WORKDIR /app

COPY . .

RUN bundle install
RUN yarn install

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-e", "production", "-b", "0.0.0.0"]
