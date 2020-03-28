FROM ubuntu:19.10

ENV DEBIAN_FRONTEND=noninteractive

# Install system tools
RUN apt-get update && \
    apt-get -y install --no-install-recommends ipython3 python3-pip \
    python3-setuptools python3-pyqt5 python3-pyqt5.qtsvg qttools5-dev-tools \
    qt5-default \
    fontconfig fontconfig-config fonts-dejavu-core \
    xfonts-100dpi xfonts-encodings xfonts-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/ipython3 /usr/bin/ipython

COPY designer_plugin.py /pydm/designer_plugin.py
ENV PYQTDESIGNERPATH /pydm/
ENV XDG_RUNTIME_DIR /tmp/

RUN python3 -m pip install --no-cache-dir epicscorelibs pydm==1.9.0

RUN mkdir -p /pydm/workspace
RUN echo 'export PS1="\u@docker:\w\\$"' > /etc/bash.bashrc

# Ugly hack to solve the issue with Python > 3.7.3
COPY patches/pyqtgraph_ImageViewTemplate_pyqt.py /usr/local/lib/python3.7/dist-packages/pyqtgraph/imageview/ImageViewTemplate_pyqt.py

# This here is ugly as well, I know... but it gives us caRepeater for free. I will change this
# in the near future
COPY --from=pydm/pydm-iocs:0.2.1 /root/epics/base/bin/linux-x86_64/caRepeater /usr/bin/caRepeater
COPY --from=pydm/pydm-iocs:0.2.1 /usr/lib/x86_64-linux-gnu/libreadline.so /usr/lib/x86_64-linux-gnu/libreadline.so.7
COPY --from=pydm/pydm-iocs:0.2.1 /usr/lib/x86_64-linux-gnu/libtinfo.so /usr/lib/x86_64-linux-gnu/libtinfo.so.5



WORKDIR /pydm/workspace