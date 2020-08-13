FROM ruby:2.5.7

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       mariadb-client\
                       nodejs

RUN mkdir /programming_drill

WORKDIR /programming_drill

ADD Gemfile /programming_drill/Gemfile
ADD Gemfile.lock /programming_drill/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /programming_drill