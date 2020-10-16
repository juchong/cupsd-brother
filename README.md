# CUPS Print Server + Brother Proprietary Driver

## Overview
This Docker image is built on the debian:jessie base image and includes the CUPS print server, many generic printer drivers (from the Debian package manager), and the proprietary driver installer from Brother.

## Download the Brother proprietary driver
The proprietary driver must be downloaded separately and placed in the same folder as the Dockerfile to be installed.

## Run the Cups server
```bash
docker run -d -p 631:631 -v /var/run/dbus:/var/run/dbus --name cupsd olbat/cupsd
```

## Add printers to the CUPS server
1. Connect to the CUPS server at [http://127.0.0.1:631](http://127.0.0.1:631)
2. Add printers: Administration > Printers > Add Printer

__Note__: The default user/password for the CUPS server is `print`/`print`

## Configure CUPS client on your machine
1. Install the `cups-client` package
2. Edit the `/etc/cups/client.conf`, set `ServerName` to `127.0.0.1:631`
3. Test the connectivity with the Cups server using `lpstat -r`
4. Test that printers are detected using `lpstat -v`
5. Applications on your machine should now detect the printers!

### Included packages
* cups, cups-client, cups-filters
* foomatic-db
* printer-driver-all, printer-driver-cups-pdf
* openprinting-ppds
* hpijs-ppds, hp-ppd
* sudo, whois
* smbclient
* gzip
* Brother driver
