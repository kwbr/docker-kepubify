# syntax=docker/dockerfile:1

# Build the application from source
FROM docker.io/golang:alpine AS build-stage

WORKDIR /project

RUN apk update && apk add --no-cache git
# Clone the kepubify source code from the Github repository
RUN git clone https://github.com/pgaskin/kepubify \
    && cd kepubify \
    && CGO_ENABLED=0 GOOS=linux go build ./cmd/kepubify

# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage

# Our script needs /bin/sh, we copy it from busybox
COPY --from=busybox:stable-uclibc /bin/sh /bin/sh

# Copy the kepubify binary from the builder stage
COPY --from=build-stage /project/kepubify/kepubify /kepubify

COPY scripts /home/kepubify
WORKDIR /home/kepubify
USER nonroot:nonroot
ENTRYPOINT ["/bin/sh", "/home/kepubify/entrypoint.sh"]
