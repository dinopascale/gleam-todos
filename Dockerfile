FROM ghcr.io/gleam-lang/gleam:v1.0.0-erlang-alpine

RUN apk update
RUN apk add sqlite gcc build-base

WORKDIR /app

COPY . /app/

EXPOSE 8000

CMD ["gleam", "run"]