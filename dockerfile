FROM store/intersystems/iris:2019.2.0.107.0-community
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

COPY . /src

WORKDIR /src

RUN /usr/irissys/dev/Cloud/ICM/changePassword.sh /src/install/password.txt

RUN iris start IRIS && sh install.sh IRIS password


