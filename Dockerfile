FROM rocker/tidyverse:4.1.1

ARG DEBIAN_FRONTEND=noninteractive

############################
# Install APT packages

# gawk for taxon-tools
# libxml2 for roxyglobals
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
gawk \
libxt6 \
&& apt-get clean

#############################
# Other custom software

ENV APPS_HOME=/apps
RUN mkdir $APPS_HOME
WORKDIR $APPS_HOME

### taxon-tools ###
WORKDIR $APPS_HOME
ENV APP_NAME=taxon-tools
RUN git clone https://github.com/camwebb/$APP_NAME.git && \
cd $APP_NAME && \
git checkout 509cb5241d97d13cf254c01f202dcb3581c3cd53 && \
make check && \
make install

############################
# Install R packages
RUN install2.r --error \
data.table

RUN R -e "remotes::install_github('joelnitta/taxastand@v0.0.0.9000')"

WORKDIR /home/rstudio/
