FROM azul/zulu-openjdk:8

RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install curl libgtk2.0-0 libcanberra-gtk-module wget git sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Eclipse now
RUN wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1/eclipse-jee-luna-SR1-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

# Install Fonts
RUN apt-get -qq update && \
    apt-get -y install curl firefox git ttf-dejavu-extra fontconfig cabextract xfonts-utils libmspack0 xterm && \
    rm -rf /var/lib/apt/lists/*

RUN wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb \
    && dpkg -i ttf-mscorefonts-installer_3.6_all.deb \
    && rm -f ttf-mscorefonts-installer_3.6_all.deb \
    && rm -rf /var/lib/apt/lists/*
RUN fc-cache -f -v

ADD run /usr/local/bin/eclipse

RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/eclipse
