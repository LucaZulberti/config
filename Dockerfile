# Keep updated with latest Brew image
FROM lucazulberti/brew:latest

# Install needed packages
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends software-properties-common && \
    sudo add-apt-repository -y ppa:fish-shell/release-4 && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        build-essential \
        clang \
        direnv \
        doxygen \
        fish \
        fzf \
        git-lfs \
        gnat \
        libclang-dev \
        libreadline-dev \
        libssl-dev \
        man-db \
        manpages \
        openssh-client \
        pkg-config \
        ripgrep \
        rsync \
        subversion \
        tmux \
        vim \
        wget \
        yarn && \
    sudo apt-get remove --purge -y software-properties-common && \
    sudo apt-get autoremove --purge -y  && \
    sudo rm -rf /var/lib/apt/lists/*

# Install brew packages
RUN brew install \
    bat \
    eza \
    fd \
    fnm \
    gitmux \
    helix \
    lazygit \
    nvim \
    rustup \
    sesh \
    television \
    tmuxp \
    tree-sitter-cli \
    zoxide

# Fix linuxbrew user home permissions
RUN sudo chmod o+rx /home/linuxbrew
