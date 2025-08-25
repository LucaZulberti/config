# Keep updated with latest Ubuntu LTS release
FROM ubuntu:latest

# Install basic packages
RUN apt-get update && apt-get install -y \
        software-properties-common \
        locales && \
    yes | unminimize && \
    rm -rf /var/lib/apt/lists/*

# Generate en_US.UTF-8 locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

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
        python3 \
        python3-venv \
        ripgrep \
        rsync \
        ruby-dev \
        subversion \
        tmux \
        unzip \
        wget \
        yarn \
        zoxide \
    && rm -rf /var/lib/apt/lists/*

# Use fish shell as default
RUN chsh -s /usr/bin/fish ubuntu

# Save it in SHELL environmnet variable
ENV SHELL=/usr/bin/fish

# Install colorls
RUN gem install colorls

# Use fish shell as default
ENTRYPOINT [ "fish"]

# Set the working directory
WORKDIR /work
