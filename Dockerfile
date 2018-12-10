#############################
#    Java with Ubuntu base  #
#############################
FROM ubuntu:18.04 as java-base

ENV                                            \
  JAVA_MAJOR_VERSION=8                         \
  LANG=C.UTF-8                                 \
  JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ \
  MYUSER_HOME=/home/myuser

RUN                                            \
  apt-get update &&                            \
  apt-get install -y --no-install-recommends   \
    openjdk-8-jdk-headless                     \
    openjdk-8-dbg                              \
    sudo                                         # required by the FlameGraph scripts

RUN                                                          \
  groupadd -g 1000 myuser                                 && \
  useradd -m -g 1000 -u 1000 myuser                       && \
  chown -R myuser:myuser $MYUSER_HOME

###################################################################
#    Build tools needed to get debugging symbols for FlameGraphs  #
###################################################################
FROM java-base as flame-graph-tools-builder
RUN                                            \
  apt-get update &&                            \
  apt-get install -y --no-install-recommends   \
    git                                        \
    ca-certificates                            \
    build-essential                            \
    cmake

RUN git clone https://github.com/jvm-profiling-tools/perf-map-agent /usr/lib/jvm/perf-map-agent
WORKDIR /usr/lib/jvm/perf-map-agent
RUN                                            \
  cmake .                                   && \
  make

RUN git clone https://github.com/brendangregg/FlameGraph /opt/FlameGraph/

##############################
#    Build application       #
##############################
FROM gradle:jdk8 as app-builder

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle installDist

##################################################################
#    Set base container, copy in artifacts, workdir, command     #
##################################################################
FROM java-base
COPY --from=flame-graph-tools-builder                        \
  /usr/lib/jvm/perf-map-agent   /usr/lib/jvm/perf-map-agent
COPY --from=flame-graph-tools-builder                        \
  /opt/FlameGraph/              /opt/FlameGraph/
COPY --from=app-builder --chown=1000:1000                                                                 \
  /home/gradle/src/build/install/docker-clocksource-cpu-test $MYUSER_HOME/docker-clocksource-cpu-test

WORKDIR $MYUSER_HOME/docker-clocksource-cpu-test/bin/

USER myuser

CMD ./docker-clocksource-cpu-test
