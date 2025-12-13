ARG FEDORA_VERSION=43
FROM fedora:$FEDORA_VERSION as lg4ff_git
RUN dnf install git -y
RUN git clone https://github.com/berarma/new-lg4ff.git

FROM fedora:$FEDORA_VERSION as build
WORKDIR workdir
VOLUME ["/build"]
COPY --from=lg4ff_git new-lg4ff ./
RUN dnf update -y
RUN dnf install kernel-modules-internal-`uname -r` kernel-devel-`uname -r` awk  -y
RUN make
RUN rm -rf ./build/new-lg4ff
RUN mkdir ./build/new-lg4ff
RUN cp ./*.ko ./build/new-lg4ff
