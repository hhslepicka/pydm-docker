FROM ubuntu:18.04

# Install system tools
RUN apt-get update
RUN apt-get -y install  wget git libreadline6-dev \
                        cmake python3 python3-dev \
                        python3-pip python3-pyqt5 \
                        libqt5svg5* qttools5-dev-tools \
                        pyqt5-dev-tools python3-pyqt5.qtsvg \
                        qt5-default

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

RUN pip3 install git+https://github.com/slaclab/pydm.git

RUN cd ~
