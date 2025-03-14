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
        build-essential \
        curl \
        doxygen \
        fish \
        fzf \
        gcc \
        git \
        git-lfs \
        libreadline-dev \
        libssl-dev \
        make \
        neovim \
        python3 \
        python3-venv \
        ripgrep \
        rsync \
        ruby-dev \
        subversion \
        tmux \
        unzip \
        yarn \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Use fish shell as default
RUN chsh -s /usr/bin/fish ubuntu

# Install colorls
RUN gem install colorls

# Use fish shell as default
ENTRYPOINT [ "fish"]

# Set the working directory
WORKDIR /work
