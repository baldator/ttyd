FROM tsl0922/musl-cross
RUN git clone --depth=1 https://github.com/tsl0922/ttyd.git /ttyd \
    && cd /ttyd && env BUILD_TARGET=i686 WITH_SSL=true ./scripts/cross-build.sh

FROM ubuntu:xenial-20200916@sha256:54e2f4a56cf3d01e5abd9fbd8ec4e4eaa03ac3f91af4578fb2349792240f4c44
COPY --from=0 /ttyd/build/ttyd /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "bash"]
