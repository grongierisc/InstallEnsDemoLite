# FROM store/intersystems/irishealth-community:2020.1.0.215.0
FROM intersystemsdc/irishealth-community:latest
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

COPY . /src

WORKDIR /src
FROM intersystemsdc/irishealth-community:latest

# Install
# $ISC_PACKAGE_INSTANCENAME name of the iris instance on docker, defaults to IRIS, valued by InterSystems
# First start the instance quietly in emergency mode with user sys and password sys
# RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
RUN iris start $ISC_PACKAGE_INSTANCENAME quietly && \
    sh install.sh $ISC_PACKAGE_INSTANCENAME sys USER && \
    /bin/echo -e "sys\nsys\n" | iris stop $ISC_PACKAGE_INSTANCENAME quietly



