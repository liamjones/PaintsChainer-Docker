FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

MAINTAINER Liam Jones <liam@stardive.co.uk>

RUN apt-get update && \
    apt-get install --assume-yes git ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV ANACONDA_VERSION=4.2.0

RUN curl --location "https://repo.continuum.io/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh" > /anaconda.sh

RUN /bin/bash anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh

ENV PAINTSCHAINER_MODEL=original \
    PAINTSCHAINER_GPU=0 \
    PAINTSCHAINER_COMMIT=471a05d \
    TINI_VERSION=0.13.2

RUN curl --location "https://github.com/liamjones/PaintsChainer-Models/releases/download/{$PAINTSCHAINER_MODEL}/unet_128_standard" > unet_128_standard && \
    curl --location "https://github.com/liamjones/PaintsChainer-Models/releases/download/{$PAINTSCHAINER_MODEL}/unet_512_standard" > unet_512_standard && \
    curl --location "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini" > /tini && \
    chmod +x /tini

ENV PATH=/opt/conda/bin:$PATH \
    CFLAGS=-I/usr/local/cuda-8.0/targets/x86_64-linux/include/:$CFLAGS \
    LDFLAGS=-L/usr/local/cuda-8.0/targets/x86_64-linux/lib/:$LDFLAGS \
    LD_LIBRARY_PATH=/usr/local/cuda-8.0/targets/x86_64-linux/lib/:$LD_LIBRARY_PATH

RUN conda install --yes opencv && \
    pip install chainer

RUN git clone https://github.com/taizan/PaintsChainer.git

WORKDIR /PaintsChainer/cgi-bin/paint_x2_unet/models/

RUN mv /unet_*_standard .

WORKDIR /PaintsChainer/static/images/

RUN apt-get update && \
    apt-get install --assume-yes \
    cron \
    tmpreaper && \
    touch line/.tmpreaper && \
    touch out/.tmpreaper && \
    touch out_min/.tmpreaper && \
    touch ref/.tmpreaper

WORKDIR /etc/cron.d/

RUN /bin/bash -c "echo -e \"* * * * * root /usr/sbin/tmpreaper --protect '*/.tmpreaper' 1h /PaintsChainer/static/images/\n\" > delete-old-paintschainer-images"
RUN chmod 0644 delete-old-paintschainer-images

WORKDIR /PaintsChainer

# CPU patch from https://github.com/taizan/PaintsChainer/pull/6
COPY cpu.patch .

RUN git checkout $PAINTSCHAINER_COMMIT && \
    git apply cpu.patch

EXPOSE 8000

ENTRYPOINT [ "/tini", "--" ]

CMD [ "sh", "-c", "cron /etc/cron.d/delete-old-paintschainer-images && python -u server.py --host 0.0.0.0 --gpu $PAINTSCHAINER_GPU"]
