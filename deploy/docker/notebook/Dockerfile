FROM jupyter/minimal-notebook:1386e2046833

LABEL maintainer "konstantin.taletskiy@axleinfo.com"

# Track semantic versioning
COPY VERSION /

USER root

# R, Octave, Java, Scala
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    ssh \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc \
    octave \
    openjdk-8-jdk \
    openjdk-11-jdk \
    maven=3.6.0-1~18.04.1 \
    libssl1.0.0 libssl-dev \
    scala \
    curl procps && \
    rm -rf /var/lib/apt/lists/* && \
    octave --eval 'pkg install -forge dataframe'
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.1.1
RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "f0a83a139a89a2ccf2316814e5ee1c0c809fca02cbaf4baf3c1fd8eb71594f06 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia
# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR

USER $NB_UID

RUN rm -f /opt/conda/conda-meta/pinned
RUN conda install --quiet --yes \
    'conda-forge::blas=*=openblas' \
    'ipywidgets=7.5*' \
    'pandas=0.25*' \
    'numexpr=2.6*' \
    'matplotlib-base=3.1.*' \
    'scipy=1.3*' \
    'seaborn=0.9*' \
    'scikit-learn=0.21*' \
    'scikit-image=0.15*' \
    'sympy=1.4' \
    'cython=0.29*' \
    'patsy=0.5*' \
    'statsmodels=0.10*' \
    'cloudpickle=1.2*' \
    'dill=0.3*' \
    'numba=0.45*' \
    'bokeh=1.3*' \
    'sqlalchemy=1.3*' \
    'hdf5=1.10*' \
    'h5py=2.9*' \
    'vincent=0.4.*' \
    'beautifulsoup4=4.8.*' \
    'protobuf=3.9.*' \
    'xlrd' && \
    conda install --quiet --yes \
    'rpy2=2.9*' \
    'r-base=3.6.1' \
    'r-irkernel=1.0*' \
    'r-plyr=1.8*' \
    'r-devtools=2.1*' \
    'r-tidyverse=1.2*' \
    'r-shiny=1.3*' \
    'r-rmarkdown=1.14*' \
    'r-forecast=8.7*' \
    'r-rsqlite=2.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=1.0*' \
    'r-htmlwidgets=1.3*' \
    'r-hexbin=1.27*' \
    'r-feather=0.3*' \
    'r-highcharter=0.7*' \
    'r-dygraphs=1.1*' \
    'r-visnetwork=2.0*' \
    'r-d3heatmap=0.6.1*' \
    'r-plotly=4.9*' \
    'r-rbokeh=0.6*' \
    'r-networkd3=0.4*' \
    'r-dt=0.5*' \
    'r-threejs=0.3*' \
    'r-rglwidget=0.2*' && \
    conda install --quiet --yes -c conda-forge \
                                feather-format \
                                voila \
                                itkwidgets \
                                dvc && \
    conda install -y -c bioconda gnuplot && \
    conda install xeus-cling xwidgets xtensor xtl xframe && \
    pip install \
                octave_kernel==0.31.0 \
                bash_kernel==0.7.2 \
                nbformat==4.4.0 \
                sos-notebook==0.20.2 \
                sos-r==0.19.1 \
                sos-bash==0.19.0 \
                sos-matlab==0.18.3 \
                sos-scala==0.18.0 \ 
                sos-javascript==0.18.0 \
                sos-python==0.18.2 \
                sos-xeus-cling==0.1.0 \
                sos-java==0.1.0 \
                sos-julia==0.18.2 \
                nbdime==1.1.0 \
                jupyterlab-git==0.8.1 \
                jupyterlab-quickopen==0.3.0 \
                opencv-python==4.1.1.26 && \
    # conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy && \
    # Install Jupyter Server extensions
    jupyter serverextension enable --py jupyterlab_git && \
    # Install Jupyter Notebook extensions
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Install JupyterLab extensions
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.0 \
                                 jupyterlab_bokeh@1.0.0 \
                                 transient-display-data@0.3.0 \
                                 jupyterlab-sos@0.5.1 \
                                 @jupyterlab/git@0.8.2 \
                                 @jupyterlab/hub-extension@1.1.2 \
                                 @jupyter-voila/jupyterlab-preview@0.1.2 \
                                 itkwidgets@0.20.1 \
                                 @aquirdturtle/collapsible_headings@0.3.3 \
                                 jupyterlab-python-file@0.3.0 \
                                 @parente/jupyterlab-quickopen@0.3.0 \
                                 jupyterlab-spreadsheet@0.2.0 \
                                 @krassowski/jupyterlab_go_to_definition@0.7.1 \
                                 jupyterlab_filetree@0.2.1 && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Add Julia packages. Only add HDF5 if this is not a test-only build since
# it takes roughly half the entire build time of all of the images on Travis
# to add this one package and often causes Travis to timeout.
#
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e "using Pkg; \
              pkg\"add Feather DataFrames NamedArrays Gadfly RDatasets IJulia InstantiateFromURL HDF5 https://github.com/probcomp/Gen\";\
              pkg\"precompile\"" && \
    # move kernelspec out of home \
    mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

#Scala kernel
ENV SCALA_VERSION 2.12.8 
ENV ALMOND_VERSION 0.6.0
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
      sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
      -o almond && \
    ./almond --install && \
    rm almond coursier

# Java kernel
RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip && \
    unzip ijava-kernel.zip -d ijava-kernel \
    && cd ijava-kernel \
    && python install.py --sys-prefix \
    && cd .. \
    && rm ijava-kernel.zip \
    && rm -rf ijava-kernel

# JavaScript and Typescript kernels
RUN npm rebuild && \
    npm install -g ijavascript itypescript && \
    ijsinstall --spec-path=full && \
    its --install=local

# Enable language kernels
RUN python -m bash_kernel.install --user && \
    python -m octave_kernel install --user && \
    python -m sos_notebook.install

# Install WIPP integration
RUN pip install jupyterlab-wipp && \
    jupyter serverextension enable --py jupyterlab_wipp && \
    jupyter labextension install jupyterlab_wipp

# Add missing kernel logos
COPY coffee.png /opt/conda/share/jupyter/kernels/java/logo-64x64.png
COPY bash.png /home/jovyan/.local/share/jupyter/kernels/bash/logo-64x64.png

# Add symbolic link to the shared filesystem
RUN ln -s /opt/shared shared

#Rebuid JupyterLab to make sure all labextensions are included
RUN jupyter lab clean
RUN jupyter lab build

EXPOSE 8888
# ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD jupyter lab --ip='0.0.0.0' --port=8888 --no-browser