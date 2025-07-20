FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV HOME=/root
ENV GO_VERSION=1.22.3
ENV BUN_INSTALL=/root/.bun

WORKDIR /root

# Install system dependencies
RUN apt update && apt install -y --no-install-recommends \
    ca-certificates curl git wget unzip build-essential \
    zsh neovim ripgrep fd-find tmux \
    python3-pip nodejs npm gnupg \
 && apt clean && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh and Spaceship theme (once)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 

# Copy in the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["zsh"]

