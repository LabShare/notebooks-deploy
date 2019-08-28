FROM jupyter/minimal-notebook:latest

# Track semantic versioning
COPY VERSION /

COPY --chown=1000 ./source source
COPY --chown=1000 ./source_nbs source_nbs
COPY --chown=1000 ./convert.sh .
RUN sh convert.sh

FROM alpine:latest

# Setup the folder hierarchy
WORKDIR /etc/
RUN mkdir /etc/Sphinx
RUN mkdir /etc/Sphinx/build

#Add the static files
COPY --from=0 /home/jovyan/source /etc/Sphinx/source

#Install python3, make, sphinx and all addons
RUN apk add --no-cache python3 make bash
RUN python3 -m ensurepip
RUN pip3 install --upgrade pip && \
    pip3 install sphinx \
                 sphinx-rtd-theme \
                 sphinx-autobuild \
                 recommonmark

CMD sphinx-autobuild -b html --host 0.0.0.0 --port 80 \
                     --poll /etc/Sphinx/source /etc/Sphinx/build
