FROM debian:testing-slim

ARG VERSION

LABEL maintainer="Sandro Jäckel <sandro.jaeckel@gmail.com>" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.authors="Sandro Jäckel <sandro.jaeckel@gmail.com>" \
  org.opencontainers.image.url="https://github.com/SuperSandro2000/docker-images/tree/master/code-server" \
  org.opencontainers.image.documentation="https://github.com/cdr/code-server" \
  org.opencontainers.image.source="https://github.com/SuperSandro2000/docker-images" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$REVISION \
  org.opencontainers.image.vendor="SuperSandro2000" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.title="code-server" \
  org.opencontainers.image.description="Run VS Code on a remote server."

RUN export user=coder \
  && groupadd -g 1000 -r $user && useradd -m -r -g 1000 -u 1000 $user

RUN apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    ca-certificates \
    dumb-init \
    git \
    wget \
  && rm -rf /var/lib/apt/lists/*

ARG VERSION=4.4.0
RUN wget -q https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server_${VERSION}_amd64.deb -O /code-server_${VERSION}_amd64.deb \
  && apt-get install -qy --no-install-recommends /code-server_${VERSION}_amd64.deb \
  && rm /code-server_${VERSION}_amd64.deb

USER coder
RUN mkdir -p /home/coder/project \
  && mkdir -p /home/coder/.local/share/code-server


# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs

RUN sudo apt-get install wget -y

RUN sudo npm install -g expo-cli
RUN sudo npm install -g create-react-app
RUN sudo npm install -g firebase-cli

RUN sudo npm install -g react-native-cli
RUN curl -o StudioInstaller.sh https://raw.githubusercontent.com/letsfoss/Android-Studio-Installer-Script/master/StudioInstaller.sh
RUN chmod +x StudioInstaller.sh
RUN ./StudioInstaller.sh
# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode



# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

RUN sudo apt install python3-pip -y

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# -----------
# use shazi script
RUN sudo wget https://shazi-cloud.web.app/shazi-script/index.sh
RUN sudo sh index.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/live-script-installer.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/code-extensions.sh
RUN bash code-extensions.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/development-environment-setup.sh
RUN echo y | bash development-environment-setup.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/installMsSql.sh
#RUN echo y | bash installMsSql.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/installMySql.sh
#RUN echo y | bash installMySql.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/installPostgresql.sh
#RUN echo y | bash installPostgresql.sh
RUN sudo wget https://shazi-cloud.web.app/sources.list/sources.list
RUN sudo mv sources.list /etc/apt/
RUN echo y | sudo apt-get update
RUN echo y | sudo apt-get upgrade
# -----------

RUN sudo apt update -y && sudo apt upgrade -y
RUN sudo apt install snapd -y
#installing flutter
RUN sudo wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.5-stable.tar.xz
RUN sudo echo y | tar xf flutter_linux_3.0.5-stable.tar.xz
RUN export PATH="$PATH:`pwd`/flutter/bin"
#installing flutter
RUN echo y | sudo apt-get install android-tools-adb android-tools-fastboot
RUN mkdir blueprints

#getting react native template
WORKDIR /home/coder/react-native
RUN wget https://shazi-cloud.web.app/templates/react-native.rar
RUN echo y | sudo apt-get install unrar
RUN unrar x react-native.rar
RUN sudo npm install
RUN echo "react-native dir"
RUN ls
WORKDIR /home/coder
RUN echo "home dir"
RUN ls
RUN mv react-native blueprints
#WORKDIR react-native
#RUN rmdir .github
#RUN npm install
#RUN echo "react-native dir"
#RUN ls
#WORKDIR /home/coder
#RUN echo "home dir"
#RUN ls
#RUN mv react-native blueprints


#react-app creation
RUN create-react-app react-app
RUN mv react-app blueprints
#RUN expo init expo-app


#swap
RUN curl https://raw.githubusercontent.com/Cretezy/Swap/master/swap.sh -o swap
RUN sudo sh swap 24G


EXPOSE 8080
ENV NODE_ENV=production
WORKDIR /home/coder/project
ENTRYPOINT [ "dumb-init", "code-server", "--host", "0.0.0.0" ]
