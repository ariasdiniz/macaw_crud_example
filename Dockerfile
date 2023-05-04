FROM ruby:3.2.0-slim-bullseye

ENV RUBY_YJIT_ENABLE=1

WORKDIR /app

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 8080

ENTRYPOINT ["ruby", "main.rb"]
