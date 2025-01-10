# Keep updated with latest Ubuntu LTS release
FROM ubuntu:latest

# Install basic packages
RUN apt-get update && apt-get install -y \
        software-properties-common \
        locales && \
    rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Add Neovim PPA (unstable for v0.10+)
RUN add-apt-repository -y ppa:neovim-ppa/unstable

# Add Fish shell PPA
RUN add-apt-repository -y ppa:fish-shell/release-3

# Install needed packages
RUN apt-get update && apt-get install -y \
        fish \
        fzf \
        gcc \
        git \
        git-lfs \
        libreadline-dev \
        make \
        neovim \
        python3 \
        python3-venv \
        ripgrep \
        tmux \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Use fish shell as default
RUN chsh -s /usr/bin/fish ubuntu

# Switch to non-root user
USER ubuntu

# Install python virtual environment and needed packages
RUN mkdir -p ~/.venv/ && \
    python3 -m venv ~/.venv/work && \
    . ~/.venv/work/bin/activate && \
    pip install \
        tmuxp \
        git+https://github.com/luarocks/hererocks

# Install hererocks environment with Lua5.1 and LuaRocks
RUN . ~/.venv/work/bin/activate && \
    hererocks ~/.hererocks/5.1 -l5.1 -rlatest

# Add symbolic link to Neovim and Tmux external config directories
RUN mkdir -p ~/.config && \
    ln -s /config/fish ~/.config/fish && \
    ln -s /config/nvim ~/.config/nvim && \
    ln -s /config/tmux ~/.config/tmux && \
    ln -s /config/tmux-powerline ~/.config/tmux-powerline && \
    ln -s /config/tmuxp ~/.config/tmuxp

# Create local directory to mount volume for persistance with correct uid:gid
RUN mkdir -p ~/.local

# Use fish shell as default
ENTRYPOINT [ "fish"]

# Set the working directory
WORKDIR /work
