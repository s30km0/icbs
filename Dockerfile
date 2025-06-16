# Use official Python image suitable for icbs
FROM python:3.11-slim

# Install build tools required for compilation
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy project files
COPY . .

# Install python dependencies and library itself
RUN pip install --no-cache-dir -r requirements.txt -e .

# Build the simulated annealing solver
WORKDIR /app/src/sa-card
RUN mkdir build && cd build && \
    cmake .. && cmake --build . -j$(nproc) && \
    cp src/sa-card /app/src/icbs/

# Default working directory and command
WORKDIR /app
CMD ["python"]
