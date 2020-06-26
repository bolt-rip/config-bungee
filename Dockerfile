FROM alpine:3.12 AS BUILD

RUN mkdir /minecraft

WORKDIR /minecraft

COPY . .

RUN apk upgrade --no-cache \
    && apk add --no-cache curl

RUN curl https://repo.repsy.io/mvn/boltrip/public/tc/oc/pgm/core/0.9-bolt-SNAPSHOT/core-0.9-bolt-20200626.103358-1.jar -Lo plugins/nerve.jar

FROM adoptopenjdk/openjdk8-openj9:alpine-slim

RUN addgroup -g 1000 minecraft && \
    adduser -u 1000 -D -G minecraft minecraft

RUN mkdir /minecraft
RUN chown minecraft:minecraft -R /minecraft
WORKDIR /minecraft
COPY --from=BUILD --chown=minecraft:minecraft /minecraft .

USER minecraft
ENTRYPOINT [ "/minecraft/run.sh" ]