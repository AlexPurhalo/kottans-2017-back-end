FROM ruby:2.3.1

# Create app directory
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

# Install app dependencies
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5


# Bundle app source
COPY . ./
RUN sequel -m db/migrations sqlite://db/database.db

EXPOSE 5000
CMD [ "foreman", "start" ]
