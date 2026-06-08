FROM mcr.microsoft.com/dotnet/sdk:8.0-bookworm-slim

ARG UID=1000
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and python
RUN apt update && \
    apt install -y git wget build-essential python3.11 python3.11-venv python3.11-dev python3-pip ffmpeg libglib2.0-0 libgl1 && \
    rm -rf /var/lib/apt/lists/*

# Ensure `python3` points to the installed python3.11
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 || true

WORKDIR /SwarmUI

# Copy repository into the image
COPY . /SwarmUI

# Set permissions and prepare runtime user
RUN chown -R $UID:$UID /SwarmUI
RUN git config --system --add safe.directory /SwarmUI
RUN useradd -m -u $UID -d /home/swarmui swarmui || true

# Remove any built binaries that shouldn't be shipped
RUN rm -rf /SwarmUI/src/bin /SwarmUI/src/obj

# Make inner launch scripts executable (harmless if they already are)
RUN chmod +x /SwarmUI/launchtools/docker-standard-inner.sh /SwarmUI/launchtools/docker-open-inner.sh || true

EXPOSE 7801

# Run as non-root user by default
USER swarmui

ENTRYPOINT ["bash", "/SwarmUI/launchtools/docker-standard-inner.sh"]
