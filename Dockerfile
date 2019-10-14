FROM ubuntu:18.04 as builder

LABEL maintainer="vo1@sanger.ac.uk" \
      version="0.0.1" \
      description="nf-sge container"

MAINTAINER  Victoria Offord <vo1@sanger.ac.uk>

USER root

# ALL tool versions used by opt-build.sh
ENV VER_BCL2FASTQ="2-20-0"
ENV VER_FASTQC="0.11.8"
ENV VER_SEQPREP="1.2"
ENV VER_EMBOSS="6.6.0"

RUN apt-get -yq update

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

RUN apt-get install -yq --no-install-recommends \
curl \
unzip \
make \
gcc \
g++ \
zlib1g-dev \
libfindbin-libs-perl \
openjdk-8-jre \
libx11-dev 

RUN apt-get -yq update

ENV OPT /opt/wsi-t113
ENV PATH $OPT/bin:$OPT/FastQC:$PATH
ENV LD_LIBRARY_PATH $OPT/lib
ENV PERL5LIB $OPT/lib/perl5

ENV DISPLAY=:0

## USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

RUN mkdir -p $OPT/bin

ADD build/opt-build.sh build/
RUN bash build/opt-build.sh $OPT

RUN chmod a+rx $OPT/bin

USER ubuntu
WORKDIR /home/ubuntu
