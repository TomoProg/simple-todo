FROM ruby:3.3

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends build-essential libsqlite3-dev git \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler rails

WORKDIR /app

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
