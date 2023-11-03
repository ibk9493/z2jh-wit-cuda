FROM jupyter/all-spark-notebook:spark-3.1.1

USER root

WORKDIR /home/jupyter

RUN chmod -R 777 /home/

RUN apt-get update
RUN conda update -y -n base conda
RUN conda uninstall -y llvmlite

COPY requirements.txt /home/requirements.txt
RUN pip install -r /home/requirements.txt
RUN pip install horovod==0.27.0
