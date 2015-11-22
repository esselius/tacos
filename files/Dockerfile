FROM alpine:3.2

RUN apk -U add ruby ruby-bundler ruby-io-console && rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/
RUN bundle install

COPY . /usr/src/app
