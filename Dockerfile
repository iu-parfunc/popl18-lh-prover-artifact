FROM fpco/stack-build:lts-8.9

RUN apt-get -y install z3

# force https on github instead of ssh
RUN git config --system url."https://github.com/".insteadOf "git@github.com:"
RUN stack config set system-ghc --global true

RUN git clone --recursive https://github.com/ucsd-progsys/liquidhaskell.git /opt/liquidhaskell
WORKDIR /opt/liquidhaskell

# "popl18" branch
RUN git fetch --all && \
   git checkout --force popl18 && \
   git submodule update --init --recursive && \
   git clean -dffx && \
   stack install --local-bin-path=/usr/local/bin
RUN stack test liquidhaskell --no-run-tests

RUN git clone -b popl18 --recursive https://github.com/iu-parfunc/verified-instances.git /opt/verified-instances
WORKDIR /opt/verified-instances
RUN stack build

RUN git clone -b popl18 --recursive https://github.com/iu-parfunc/lvars.git /opt/lvars
WORKDIR /opt/lvars
RUN stack build
RUN stack test --no-run-tests
RUN stack bench --no-run-benchmarks

ENV DOCKER=false TIMEIT=false
CMD cd /opt/liquidhaskell && \
    stack test liquidhaskell && \
    cd /opt/verified-instances && \
    find . -type d -name '.liquid' -exec rm -rf {} \+ && \
    make && \
    cd /opt/lvars && \
    make
