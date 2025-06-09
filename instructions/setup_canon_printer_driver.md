# Setup Canon Printer Driver

I don't remember exactly what worked, but these are the steps I took (probably
only the last one or two that made a difference):

1. `sudo add-apt-repository ppa:michael-gruz/canon`
1. `sudo add-apt-repository --remove ppa:michael-gruz/canon`
1. `sudo apt-add-repository ppa:thierry-f/fork-michael-gruz`
1. `lpstat -p -d`
1. `lpoptions`
1. `lpoptions -d MG2900-series`
1. `sudo apt install cups-filters --simulate`
1. `vi /usr/share/cups/mime/mime.types`
1. `sudo apt install cnijfilter2`
1. `sudo apt install cnrdrvcups-lipslx cnrdrvcups-ufr2-us`
1. `sudo apt install scangearmp2`
1. `cdl ~/software/cnijfilter2-5.00-1-deb`
1. `./install.sh`
1. `lp -d MG2900USB Tyler-Xmas-Shipping-Label.pdf`
1. `lpoptions -d MG2900-series`

## Maybe useful websites

1. https://tutorialforlinux.com/2022/05/27/how-to-install-canon-mg2920-mg2922-mg2924-printer-on-ubuntu-22-04/
1. https://www.canon-europe.com/support/consumer/products/printers/pixma/mg-series/pixma-mg2940.html?type=drivers&detailId=tcm:13-1196745&os=linux%20(64-bit)&language=en&productTcmUri=tcm:13-1173254
1. https://itsubuntu.com/how-to-install-canon-printer-driver-in-ubuntu-22-04-lts/#google_vignette
1. Local cups: http://localhost:631/printers

1. https://gdlp01.c-wss.com/gds/5/0100006265/01/cnijfilter2-5.00-1-deb.tar.gz

