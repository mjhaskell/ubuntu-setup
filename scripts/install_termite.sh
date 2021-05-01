#!/bin/sh

echo_blue "Installing termite"

CUR_DIR="$(pwd)"

sudo apt update
sudo apt install -y g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool
sudo apt install -y libpcre2-dev libglib3.0-cil-dev libgnutls28-dev
sudo apt install -y libgirepository1.0-dev libxml2-utils gperf
sudo apt install -y dh-autoreconf libglib2.0-dev libpango1.0-dev

cd ~/software
mkdir termite_raw && cd termite_raw

pkgbase="termite"
srcdir="${HOME}/software/termite_raw/src"
pkgdir="${HOME}/software/termite_raw/pkg"
vte_ver="0.56.2.a"

git clone --recursive https://github.com/thestinger/termite#commit=7e9a93b421b9596f8980645a46ac2ad5468dac06
git clone --recursive https://github.com/thestinger/vte-ng#tag=${vte_ver}

cd vte-ng
echo 'sources: $(BUILT_SOURCES)' >> src/Makefile.am
NOCONFIGURE=1 ./autogen.sh

./configure \
  --prefix="${srcdir}/vte-static" \
  --localedir="/usr/share/${pkgbase}/locale" \
  --enable-static \
  --disable-shared \
  enable_introspection=no \
  enable_vala=no \
  --disable-gtk-doc \
  --disable-glade-catalogue

make -C src sources install-exec install-data -j 1
make install-pkgconfigDATA

cd "../${pkgbase}"
export PKG_CONFIG_PATH="${srcdir}/vte-static/lib/pkgconfig"
make

cd ..

make -C vte-ng/po DESTDIR="${pkgdir}" install-data
make -C "${pkgbase}" DESTDIR="${pkgdir}" PREFIX=/usr install

# install

sudo cp ${pkgdir}/usr/bin/termite /usr/local/bin/.
sudo cp ${pkgdir}/usr/share/terminfo/x/xterm-termite /usr/lib/terminfo/x/.
sudo cp ${pkgdir}/usr/share/applications/termite.desktop /usr/share/applications/.
sudo cp ${pkgdir}/usr/share/man/man1/termite.1 /usr/share/man/man1/.
sudo cp ${pkgdir}/usr/share/man/man5/termite.config.5 /usr/share/man/man5/.

if [ -f /usr/local/bin/termite ]; then
    #mkdir -p ~/.config/termite
    #cp /etc/xdg/termite/config ~/.config/termite/config
    echo_green "Termite installed"
else
    echo_red "Installation unsuccessful"
fi

cd $CUR_DIR
