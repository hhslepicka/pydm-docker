FROM ubuntu:18.04

# Install system tools
RUN apt-get update && \
    apt-get -y install  g++ wget git libreadline6-dev cmake \
                        python3-pyqt5 python3-pip \
                        python3-pyqt5.qtsvg qttools5-dev-tools  qt5-default && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install EPICS base
RUN mkdir epics
WORKDIR epics
RUN wget https://epics.anl.gov/download/base/base-3.15.5.tar.gz
RUN tar zxf base-3.15.5.tar.gz
WORKDIR base-3.15.5
RUN make clean && make && make install
ENV EPICS_BASE /epics/base-3.15.5
ENV PYEPICS_LIBCA /epics/base-3.15.5/lib/linux-x86_64/libca.so
ENV PATH $EPICS_BASE/bin/linux-x86_64/:$PATH

COPY designer_plugin.py /pydm/designer_plugin.py
ENV PYQTDESIGNERPATH /pydm/

RUN pip3 install pydm==1.6.1

WORKDIR /root/
