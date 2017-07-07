FROM quay.io/ukhomeofficedigital/nodejs-base:v6.11.0-0

ENV PTTG_API_ENDPOINT localhost
ENV USER pttg
ENV GROUP pttg
ENV NAME pttg-fs-ui

ARG VERSION

WORKDIR /app

RUN groupadd -r ${GROUP} && \
    useradd -r -g ${GROUP} ${USER} -d /app && \
    mkdir -p /app && \
    chown -R ${USER}:${GROUP} /app

RUN npm --loglevel warn install --only=prod
COPY . /app
RUN npm --loglevel warn run postinstall

RUN chmod a+x /app/run.sh

USER pttg

EXPOSE 8000

ENTRYPOINT /app/run.sh
