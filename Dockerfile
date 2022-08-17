# Start from the code-server Debian base image
FROM codercom/code-server:4.5.1

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

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

#fix nodejs
RUN sudo fallocate -l 1G /swapfile
RUN sudo chmod 600 /swapfile
RUN sudo mkswap /swapfile
RUN echo ^C | sudo swapon /swapfile
RUN sudo swapon --show
RUN sudo cp /etc/fstab /etc/fstab.bak
RUN echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
RUN sudo sysctl vm.swappiness=10
RUN echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
RUN sudo sysctl vm.vfs_cache_pressure=50
RUN echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]


