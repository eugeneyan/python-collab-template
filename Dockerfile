ARG BASE_IMAGE=python:3.8

FROM ${BASE_IMAGE} as base

LABEL maintainer='eugeneyan <eugeneyan@eugeneyan.com>'

# Use the opt directory as our dev directory
WORKDIR /opt

ENV PYTHONUNBUFFERED TRUE

COPY requirements.dev .
COPY requirements.prod .

# Install python dependencies
RUN pip install --upgrade pip \
    && pip install --no-cache-dir wheel \
    && pip install --no-cache-dir -r requirements.dev \
    && pip install --no-cache-dir -r requirements.prod \
    && pip list