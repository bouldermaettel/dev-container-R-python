
FROM openanalytics/r-base

# system libraries of general use
# libcairo2-dev for RpostgreSQL package
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libpq-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# system library dependency for the shiny app
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# ENV RENV_VERSION 0.15.5
# RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
# RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# COPY renv.lock renv.lock

# # copy renv auto-loader tools into the container
# RUN mkdir -p renv
# COPY .Rprofile .Rprofile
# COPY renv/activate.R renv/activate.R
# COPY renv/settings.dcf renv/settings.dcf

# # install packages from renv.lock
# RUN R -e "renv::restore()"


# install packages
RUN R -e "install.packages(c('shiny', 'shinyalert', 'RPostgreSQL', 'rmarkdown', 'DT', 'data.table','shinythemes' ,'shinyWidgets', 'DT', 'tidyverse', 'shinydashboard', 'shinydashboardPlus','data.table', 'fresh','shinyjs', 'shinyBS','openxlsx', 'excelR'), repos='https://cloud.r-project.org/')"

#'dplyr','tibble','readr'
## install dependencies if required
#RUN R -e "install.packages('DT', repos='https://cloud.r-project.org/')"

################################################################################
# Python installation
################################################################################

RUN apt-get update && \
   apt-get install -y python3 python3-pip && \
   rm -rf /var/lib/apt/lists/*

# Dash and dependencies
RUN pip3 install matplotlib

# copy the app to the image
RUN mkdir /root/app/
COPY app /root/app/

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY app/Rprofile.site /usr/lib/R/etc/
#RUN mkdir /root/data/
#COPY data /root/data/
#RUN mkdir /root/www/
#COPY www /root/www/

EXPOSE 3838
EXPOSE 5432

CMD ["R", "-e", "shiny::runApp('/root/app/app.R')"]


# docker build -t bouldermaettel/duplicate-finder .
# docker run -it -p 3838:3838 duplicate-finder
# docker kill $(docker ps -q)

# docker run -d -v /var/run/docker.sock:/var/run/docker.sock --net sp-net -p 8080:8080 sp-built
# bouldermaettel@bouldermaettelsZBOOK:~/PycharmProjects/A848/Docker_container$ R -e "shiny::runApp('app')"

# docker tag duplicate-finder:latest bouldermaettel/dupliate-finder:latest
# docker login -u bouldermaettel
# docker push bouldermaettel/dupliate-finder:latest
# bouldermaettel@bouldermaettelsZBOOK:~/PycharmProjects/A848_standalone/ R -e "shiny::runApp('app.R')"