FROM alpine:3.12 AS BUILD

RUN mkdir /minecraft

WORKDIR /minecraft

COPY . .

RUN apk upgrade --no-cache \
    && apk add --no-cache curl

RUN curl https://github.com/itzg/mc-monitor/releases/download/0.6.0/mc-monitor_0.6.0_linux_amd64.tar.gz \
    -Lo mc-monitor.tar.gz && tar xzf mc-monitor.tar.gz && \
    rm LICENSE README.md mc-monitor.tar.gz && chmod +x mc-monitor

RUN curl https://repo.repsy.io/mvn/boltrip/public/rip/bolt/nerve/1.0.0-SNAPSHOT/nerve-1.0.0-20200624.224324-1.jar -Lo plugins/nerve.jar

FROM adoptopenjdk/openjdk8-openj9:alpine-slim

RUN addgroup -g 1000 minecraft && \
    adduser -u 1000 -D -G minecraft minecraft

RUN mkdir /minecraft
RUN chown minecraft:minecraft -R /minecraft
WORKDIR /minecraft
COPY --from=BUILD --chown=minecraft:minecraft /minecraft .

USER minecraft
ENTRYPOINT [ "/minecraft/run.sh" ]