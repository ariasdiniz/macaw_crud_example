FROM ruby:latest

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 8080

ENTRYPOINT ["ruby", "main.rb"]
