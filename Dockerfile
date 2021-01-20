# Dockerfile.rails

FROM ruby:2.7.2

RUN addgroup --gid 1000 user
RUN adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

RUN gem install rails bundler

ADD . /opt/app

RUN chown -R user:user /opt/app
WORKDIR /opt/app
RUN gem install

USER $USER_ID
CMD ["rails server"]
