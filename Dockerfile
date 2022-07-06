FROM ubuntu:20.04
LABEL org.opencontainers.image.authors="michael.schmidt@vumc.org"
LABEL org.opencontainers.image.url="https://github.com/MichaelSchmidt82/docker-curation-base"
LABEL org.opencontainers.image.documentation="https://github.com/MichaelSchmidt82/docker-curation-base"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="All of Us Curation base image"
LABEL org.opencontainers.image.description="The root image from which all curation images are dervived from."

#* Paths from which work is build from
ENV PROJECT_NAME="curation"
ENV PROJECT_ROOT="/project/${PROJECT_NAME}"

ENV VENV_PATH "/project/project_env"
ENV VENV_ACTIVATE "${VENV_PATH}/bin/activate"

ENV PATH=${VENV_PATH}/bin:$PATH
ENV PYTHONPATH=${PROJECT_ROOT}:"${PYTHONPATH}"

#* Install basic tools and dependencies
RUN apt update \
    && apt upgrade -y \
    && apt install -y \
    ca-certificates \
    gnupg \
    curl \
    wget \
    git \
    python3.8-dev \
    python3.8-venv \
    python3-pip \
    python3-wheel \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

#* Copy in requirements.txt and install python deps
COPY requirements.txt "${VENV_PATH}/requirements.txt"
RUN python -m venv "${VENV_PATH}" \
    && echo "source ${VENV_ACTIVATE}" \
    && . "${VENV_ACTIVATE}" \
    && python -m pip install --upgrade pip setuptools wheel \
    && python -m pip install -r "${VENV_PATH}/requirements.txt"
