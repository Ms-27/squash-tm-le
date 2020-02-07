FROM openjdk:8-jre-alpine
LABEL maintainer="oborde@henix.fr"

ARG SQUASH_VERSION=1.21.0
ARG SQUASH_URL=http://repo.squashtest.org/distribution/squash-tm-${SQUASH_VERSION}.RELEASE.tar.gz

ENV SQUASH_VERSION ${SQUASH_VERSION}
ENV SQUASH_URL ${SQUASH_URL}   

ENV USER squash-tm
ENV PASSWORD initial_pw
ENV DATABASE squashtm
ENV PORT 5432

EXPOSE 8080

RUN wget ${SQUASH_URL} ; tar xvf squash-tm-${SQUASH_VERSION}.RELEASE.tar.gz ; rm squash-tm-${SQUASH_VERSION}.RELEASE.tar.gz

RUN apk add --no-cache postgresql-client

WORKDIR /squash-tm/bin
RUN sed -i "s/DB_TYPE=h2/DB_TYPE=postgresql/" startup.sh ; sed -i "s!DB_URL=jdbc:h2:../data/squash-tm!DB_URL=jdbc:postgresql://postgre-squash:\${PORT}/\${DATABASE}!" \
startup.sh ; sed -i "s/DB_USERNAME=sa/DB_USERNAME=\${USER}/" startup.sh ; sed -i "s/DB_PASSWORD=sa/DB_PASSWORD=\${PASSWORD}/" startup.sh ; chmod +x startup.sh

COPY init_and_start.sh .

CMD chmod +x init_and_start.sh ; ./init_and_start.sh