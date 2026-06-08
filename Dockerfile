FROM mcr.microsoft.com/dotnet/sdk:8.0-bookworm-slim

ARG UID=1000

RUN apt update && \
    apt install -y git wget build-essential python3.11 python3.11-venv python3.11-dev python3-pip ffmpeg libglib2.0-0 libgl1 && \
    rm -rf /var/lib/apt/lists/*

COPY . /SwarmUI
RUN chown -R $UID:$UID /SwarmUI
RUN git config --global --add safe.directory '*'
RUN useradd -u $UID swarmui
RUN rm -rf /SwarmUI/src/bin /SwarmUI/src/obj

EXPOSE 7801
ENTRYPOINT ["bash", "/SwarmUI/launchtools/docker-standard-inner.sh"]
