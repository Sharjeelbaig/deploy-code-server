FROM codercom/code-server:4.4.0


#ADD swapping.sh /
#ENV SWAPPINESS 10
#ENV SWAP_SIZE_IN_GB **None**
#VOLUME /user
#CMD ["/swapping.sh"]

RUN sudo apt-get update \
 && sudo apt-get install -y unzip

# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs

RUN sudo apt-get install wget -y

#RUN sudo mkdir /root/.npm
#RUN echo y | sudo chown -R 1000:1000 "/root/.npm"
#RUN echo y | sudo npx npm install -g expo-cli
RUN echo y | sudo npm install -g create-react-app
RUN echo y | sudo npm install -g firebase-cli




# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make
RUN sudo apt-get update
RUN echo y | sudo apt install python3-pip --fix-missing

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# -----------
# use shazi script
RUN sudo wget https://shazi-cloud.web.app/shazi-script/index.sh
RUN sudo sh index.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/live-script-installer.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/development-environment-setup.sh
RUN echo y | bash development-environment-setup.sh
RUN sudo wget https://shazi-cloud.web.app/shazi-script/code-extensions.sh
RUN bash code-extensions.sh
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
#RUN sudo wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.5-stable.tar.xz
#RUN sudo echo y | tar xf flutter_linux_3.0.5-stable.tar.xz
#RUN export PATH="$PATH:`pwd`/flutter/bin"
#installing flutter
#RUN echo y | sudo apt-get install android-tools-adb android-tools-fastboot
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
#RUN curl https://raw.githubusercontent.com/Cretezy/Swap/master/swap.sh -o swap
#RUN sudo sh swap 24G


# Install terraform
COPY --from=hashicorp/terraform:1.1.9 /bin/terraform /bin/
RUN terraform version

# Install awscli
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#  && unzip -qq awscliv2.zip \
#  && sudo ./aws/install \
#  && rm -rf ./awscliv2.zip ./aws
#RUN aws --version



# install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo bash
RUN helm version

# fluxcli install
RUN curl -s https://fluxcd.io/install.sh | sudo bash
RUN flux --version
#Changing working dir
WORKDIR /home/coder/main


