FROM golang:1.24.4

WORKDIR /app
COPY ./src/main.go .

RUN go build -o rng-api main.go

EXPOSE 8080

CMD ["./rng-api"]

