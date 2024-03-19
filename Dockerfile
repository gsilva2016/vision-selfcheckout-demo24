# only CPU works with this image
#FROM ultralytics/ultralytics:8.1.17-cpu
#FROM ultralytics/ultralytics:8.1.29-cpu
FROM openvino/ubuntu22_dev:2024.0.0

WORKDIR /yolo_ov_demo
user root
ENV DEBIAN_FRONTEND=noninteractive
ARG BUILD_DEPENDENCIES="vim libgtk2.0-dev pkg-config python3-opencv python3-tk"
RUN apt -y update && \
    apt install -y ${BUILD_DEPENDENCIES} && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
RUN apt -y update && apt install -y wget && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

#RUN wget -O sample.mp4 https://github.com/intel-iot-devkit/sample-videos/raw/master/store-aisle-detection.mp4 
RUN wget -O sample.mp4 https://download.pexels.com/vimeo/421906504/pexels-karolina-grabowska-4465029.mp4?width=1920
RUN pip install "paho-mqtt<2.0.0" ultralytics==8.1.29
RUN pip install "mpmath<1.4.0"
COPY vision24-demo.py .
COPY allow_x11_display_docker_openvino.patch /usr/local/lib/python3.10/dist-packages/ultralytics/utils
RUN cd /usr/local/lib/python3.10/dist-packages/ultralytics/utils; patch < allow_x11_display_docker_openvino.patch
COPY allow_openvino_device_change.patch /usr/local/lib/python3.10/dist-packages/ultralytics/nn
RUN cd /usr/local/lib/python3.10/dist-packages/ultralytics/nn; patch < allow_openvino_device_change.patch
