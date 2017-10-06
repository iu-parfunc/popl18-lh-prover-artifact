FROM debian:stable

# install deps
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update && \
    apt-get -y install z3 git-core curl build-essential time libgmp-dev sloccount locales && \
    update-locale LANG=C.UTF-8 && \
    apt-get -y clean autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set shell to bash
RUN ln -sf /bin/bash /bin/sh

# set utf8 locale
ENV LANG C.UTF-8

 # install stack
RUN curl -L https://github.com/commercialhaskell/stack/releases/download/v1.5.1/stack-1.5.1-linux-x86_64-static.tar.gz | \
     tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

# force https on github instead of ssh
RUN git config --system url."https://github.com/".insteadOf "git@github.com:"

# add popl18 user
RUN useradd -m popl18
USER popl18

# install ghc
RUN stack --resolver=lts-8.9 --install-ghc setup

# liquidhaskell
WORKDIR /home/popl18
RUN git clone --depth 10 -b popl18 --recursive https://github.com/ucsd-progsys/liquidhaskell.git
WORKDIR /home/popl18/liquidhaskell
ENV PATH "/home/popl18/.local/bin:${PATH}"
RUN stack install
RUN stack test liquidhaskell --no-run-tests

# for benchmarks
ENV DOCKER=false TIMEIT=true

# verified-instances
WORKDIR /home/popl18
RUN git clone --depth 10 -b popl18 --recursive https://github.com/iu-parfunc/verified-instances.git
WORKDIR /home/popl18/verified-instances
RUN make build

# lvars
WORKDIR /home/popl18
RUN git clone --depth 10 -b popl18 --recursive https://github.com/iu-parfunc/lvars.git
WORKDIR /home/popl18/lvars
RUN make test

WORKDIR /home/popl18

# counting scripts
RUN stack --resolver lts-9.6 install haskell-src-exts-1.19.1
COPY CountTypeSigs.hs .
COPY lh-count.sh .

CMD cd /home/popl18/liquidhaskell && \
    stack test liquidhaskell && \
    cd /home/popl18/verified-instances && \
    make check && \
    cd /home/popl18/lvars && \
    make check
