FROM apache/airflow:2.10.2

USER root

# Install build tools needed for pyarrow
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    python3-dev \
    git \
    curl \
    libssl-dev \
    libffi-dev \
    && apt-get clean

USER airflow

COPY requirements.txt /requirements.txt

RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /requirements.txt
