FROM golang:1.16-alpine3.13

RUN apk add -U --no-cache ca-certificates jq sed
RUN go get github.com/nats-io/nats.go/examples/nats-pub

COPY entrypoint.sh /entrypoint.sh
COPY actions.creds /actions.creds

ENTRYPOINT ["/entrypoint.sh"]
