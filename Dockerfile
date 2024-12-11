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

# Install needed packages
RUN apt-get update && apt-get install -y \
        fzf \
        gcc \
        git \
        git-lfs \
        luarocks \
        make \
        neovim \
        python3 \
        python3-venv \
        python-is-python3 \
        tmux \
        unzip \
        wget \
        yarn && \
    rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER ubuntu

# Install tmuxp in virtual environment
RUN mkdir -p ~/.venv/ && \
    python3 -m venv ~/.venv/work && \
    . ~/.venv/work/bin/activate && \
    pip install tmuxp

# Add symbolic link to Neovim and Tmux external config directories
RUN mkdir -p ~/.config && \
    ln -s /config/nvim ~/.config/nvim && \
    ln -s /config/tmux ~/.config/tmux && \
    ln -s /config/tmux-powerline ~/.config/tmux-powerline && \
    ln -s /config/tmuxp ~/.config/tmuxp

# Create local directory to mount volume for persistance with correct uid:gid
RUN mkdir -p ~/.local

# Customize environment
ENV TERM=xterm-256color
ENV TMUXP_CONFIGDIR=~/.config/tmuxp/sessions
RUN echo 'alias tmuxs="~/.config/tmuxp/tmuxp-sessionizer"' >> ~/.bashrc && \
    echo 'alias tmux="tmux -f ~/.config/tmux/tmux.conf"' >> ~/.bashrc && \
    echo 'export TMUXP_CONFIGDIR=~/.config/tmuxp/sessions' >> ~/.bashrc && \
    echo '. ~/.venv/work/bin/activate' >> ~/.bashrc

# Set the working directory
WORKDIR /work
