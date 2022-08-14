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


RUN sudo npm install -g react-native-cli
RUN curl -o StudioInstaller.sh https://raw.githubusercontent.com/letsfoss/Android-Studio-Installer-Script/master/StudioInstaller.sh
RUN chmod +x StudioInstaller.sh
RUN ./StudioInstaller.sh
# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension zhuangtongfa.Material-theme
RUN code-server --install-extension  ms-python.python
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension es7-react-js-snippets
RUN code-server --install-extension msjsdiag.vscode-react-native
RUN code-server --install-extension vscjava.vscode-java-pack
RUN code-server --install-extension vscjava.vscode-java-debug
RUN code-server --install-extension tushortz.pygame-snippets
RUN code-server --install-extension  ms-vscode.cpptools
RUN code-server --install-extension ms-vscode.cpptools-extension-pack
RUN code-server --install-extension ms-vscode.vscode-typescript-next
RUN code-server --install-extension Angular.ng-template
RUN code-server --install-extension johnpapa.Angular2
RUN code-server --install-extension segerdekort.angular-cli
RUN code-server --install-extension Dart-Code.flutter
RUN code-server --install-extension Dart-Code.dart-code
RUN code-server --install-extension jsayol.firebase-explorer
RUN code-server --install-extension hasanakg.firebase-snippets
RUN code-server --install-extension acchu99.firebase-react-snippets
RUN code-server --install-extension chris-noring.node-snippets
RUN code-server --install-extension ExpressSnippets.vscode-express-snippets
RUN code-server --install-extension ms-ossdata.vscode-postgresql
RUN code-server --install-extension dennisvhest.npm-browser
RUN code-server --install-extension hollowtree.vue-snippets
RUN code-server --install-extension samyakbumb.samyak
RUN code-server --install-extension dracula-theme.theme-dracula
RUN code-server --install-extension RobbOwen.synthwave-vscode
RUN code-server --install-extension enkia.tokyo-night
RUN code-server --install-extension whizkydee.material-palenight-theme
RUN code-server --install-extension arcticicestudio.nord-visual-studio-code
RUN code-server --install-extension brenix.hacker-theme
RUN code-server --install-extension  PKief.material-icon-theme
RUN code-server --install-extension monokai.theme-monokai-pro-vscode
RUN code-server --install-extension teabyii.ayu
RUN code-server --install-extension be5invis.vscode-icontheme-nomo-dark
# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# -----------
# use shazi script
RUN sudo wget https://shazi-cloud.web.app/shazi-script/index.sh
RUN sudo sh index.sh
# -----------


# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]







