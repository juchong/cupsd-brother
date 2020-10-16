ARG MAINTAINER
FROM debian:jessie
MAINTAINER $MAINTAINER

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN dpkg --add-architecture i386
RUN apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  smbclient \
  printer-driver-cups-pdf \
  apt-utils\
  gzip\
  libstdc++5:i386\
  libstdc++6:i386\
  libgcc1:i386\
  zlib1g:i386\
  libncurses5:i386\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

#Install the Brother proprietary driver
COPY linux-brprinter-installer-2.2.2-1.gz /tmp/linux-brprinter-installer-2.2.2-1.gz
RUN gunzip /tmp/linux-brprinter-installer-2.2.2-1.gz
RUN chmod +x /tmp/linux-brprinter-installer-2.2.2-1
RUN yes | ./tmp/linux-brprinter-installer-2.2.2-1 HL-2280DW -y

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Configure cups remote admin
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Patch the default configuration file to only enable encryption if requested
RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
