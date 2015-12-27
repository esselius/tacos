FROM alpine:3.2

ENV PATH $PATH:bin

RUN apk -U add ruby-bundler ruby-dev git make gcc libc-dev && rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/
RUN bundle install

COPY . /usr/src/app
