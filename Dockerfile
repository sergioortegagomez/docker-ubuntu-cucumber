FROM ubuntu:18.10

LABEL author = "Sergio Ortega Gomez"
LABEL email = "sergio.ortega.gomez@gmail.com"
LABEL version = "0.1.0"
LABEL description = "Ubuntu Desktop Mate with Cucumber. \
Libraries: cucumber, gherkin, capybara, pry, rspec, selenium-webdriver, selenium-cucumber, cucumber-api, cucumber-screenshot. \
GitHub: https://github.com/sergioortegagomez/docker-ubuntu-cucumber \
Example: https://github.com/segodev/dynamic-content-system"

# Envirenment variables
ENV DEBIAN_FRONTEND noninteractive
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# Add basic user
RUN useradd -ms /bin/bash ubuntu
RUN echo "ubuntu:ubuntu" | chpasswd
RUN usermod -aG sudo ubuntu

# Install library
RUN apt-get update && apt-get install -yqq --no-install-recommends \
    ca-certificates git curl wget vim zsh htop atop unzip xvfb \
    autoconf automake libtool g++ m4 mc bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev \
    openssh-server supervisor sudo tzdata epiphany-browser \
    default-jdk default-jre default-jdk-headless default-jre-headless
    
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

#install Sego ZSH Theme
RUN curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
RUN git clone https://github.com/sergioortegagomez/sego-zsh-theme.git
RUN cp ./sego-zsh-theme/sego.zsh-theme ~/.oh-my-zsh/themes/. 
RUN sed -i -- 's/ZSH_THEME="robbyrussell"/ZSH_THEME="sego"/g' /root/.zshrc
ENV SHELL=/bin/zsh
RUN cp /root/.zshrc /home/ubuntu/.zshrc
RUN cp -R /root/.oh-my-zsh /home/ubuntu
RUN echo "SHELL=/bin/zsh" >> /home/ubuntu/.profile
RUN sed -i -- 's/ZSH_THEME="robbyrussell"/ZSH_THEME="sego"/g' /home/ubuntu/.zshrc
RUN sed -i -- 's/root/home\/ubuntu/g' /home/ubuntu/.zshrc
RUN chsh -s /bin/zsh ubuntu

# Install Mate Desktop
RUN apt-get install -yqq \
    mate-desktop-environment-core mate-themes mate-accessibility-profiles mate-applet-appmenu mate-applet-brisk-menu \
    mate-applets mate-applets-common mate-calc mate-calc-common mate-dock-applet mate-hud mate-indicator-applet \
    mate-indicator-applet-common mate-menu mate-notification-daemon mate-notification-daemon-common mate-utils \
    mate-utils-common mate-window-applets-common mate-window-buttons-applet mate-window-menu-applet mate-window-title-applet \
    ubuntu-mate-icon-themes ubuntu-mate-themes firefox
    
# Install XRDP VNC Server
RUN apt-get install -yqq xrdp xorgxrdp tightvncserver
ADD xrdp.ini /etc/xrdp/xrdp.ini

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update
RUN apt-get install -yqq google-chrome-stable

# Install firefox and chrome WebDrivers
RUN wget -q https://github.com/mozilla/geckodriver/releases/download/v0.22.0/geckodriver-v0.22.0-linux64.tar.gz
RUN tar zxfv geckodriver-v0.22.0-linux64.tar.gz
RUN mv geckodriver /usr/local/bin
RUN rm geckodriver-v0.22.0-linux64.tar.gz
RUN wget -q https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/local/bin
RUN rm chromedriver_linux64.zip

# Selenium Server
COPY selenium-server-standalone-3.14.0.jar /opt/selenium-server-standalone-3.14.0.jar

# Installs Ruby Gems
RUN apt-get install -yqq ruby 2.2.0
RUN apt-get install -yqq ruby-dev
RUN gem install cucumber
RUN gem install gherkin
RUN gem install capybara
RUN gem install pry
RUN gem install rspec
RUN gem install selenium-webdriver
RUN gem install selenium-cucumber
RUN gem install cucumber-api
RUN gem install cucumber-screenshot

# Autoclean y autoremove
RUN apt-get -y autoclean && apt-get -y autoremove

# Ports
EXPOSE 22
EXPOSE 3389

# Workspace
RUN mkdir -p /opt/cucumber

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ARG DESKTOP=false
ENV DESKTOP=$DESKTOP

WORKDIR /opt/
CMD ["/opt/entrypoint.sh"]
