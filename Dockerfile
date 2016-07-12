FROM python:3.4

RUN apt-get update && apt-get install -y \
		libblas-dev \
		liblapack-dev\
    	libatlas-base-dev \
		gfortran \
        python3-pip \
		&& \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U distribute \
        setuptools \
        pip

RUN pip --no-cache-dir install \
       	ipykernel \
        jupyter \
        numpy \
        matplotlib \
        scipy \
        scikit-image \
        scikit-learn \
        && \
    python3 -m ipykernel.kernelspec

COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly:
# https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

ENV TENSORFLOW_VERSION 0.9.0

RUN pip --no-cache-dir install \
    	https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${TENSORFLOW_VERSION}-cp34-cp34m-linux_x86_64.whl

# tensorboard
EXPOSE 6006

# jupyter
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh &"]
