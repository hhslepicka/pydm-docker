FROM ubuntu:19.10

ENV DEBIAN_FRONTEND=noninteractive

# Install system tools
RUN apt-get update && \
    apt-get -y install --no-install-recommends python3-pip python3-setuptools \
                        python3-pyqt5 python3-pyqt5.qtsvg qttools5-dev-tools \
                        qt5-default \
                        fontconfig fontconfig-config fonts-dejavu-core \
                        xfonts-100dpi xfonts-encodings xfonts-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY designer_plugin.py /pydm/designer_plugin.py
ENV PYQTDESIGNERPATH /pydm/
ENV XDG_RUNTIME_DIR /tmp/

RUN python3 -m pip install --no-cache-dir epicscorelibs pydm==1.9.0

RUN mkdir -p /pydm/workspace
RUN echo 'export PS1="\u@docker:\w\\$"' > /etc/bash.bashrc
WORKDIR /pydm/workspace