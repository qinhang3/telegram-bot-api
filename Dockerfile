FROM alpine:3.7 as builder
WORKDIR /server

RUN apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake
RUN mkdir ./telegram-bot-api
COPY . ./telegram-bot-api/
RUN mkdir ./telegram-bot-api/build
RUN cd ./telegram-bot-api/build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=.. ..
RUN cd ./telegram-bot-api/build && \
  cmake --build . --target install
RUN strip telegram-bot-api/bin/telegram-bot-api

FROM alpine:3.7
RUN apk add --update openssl libstdc++
COPY --from=builder /server/telegram-bot-api/bin/telegram-bot-api /bin/telegram-bot

ENTRYPOINT ["/bin/telegram-bot"]

#FROM https://github.com/tdlib/telegram-bot-api/issues/7#issuecomment-721907642