#!/bin/sh
[ `grep -c 'osd.language=pl_PL' </etc/enigma2/settings` -gt 0 ] && isPL=1 || isPL=0

cd /tmp
[ -e /tmp/listakanalow.zip ] && rm -f /tmp/listakanalow.zip
[ -e /tmp/listakanalow ] && rm -fr /tmp/listakanalow
wget -q https://github.com/daniel00xE2/listakanalow/blob/main/listakanalow.zip -O /tmp/listakanalow.zip
if [ $? -gt 0 ] ;then
  wget -q "--no-check-certificate" https://github.com/daniel00xE2/listakanalow/blob/main/listakanalow.zip -O /tmp/listakanalow.zip
  if [ $? -gt 0 ] ;then
    [ $isPL -eq 1 ] && echo "błąd pobierania archiwum, koniec" || echo "error downloading archive, end"
    exit 1
  fi
else
	[ $isPL -eq 1 ] && echo "Archiwum pobrane" || echo "Archive downloaded"
fi
7z -x /tmp/listakanalow.zip -C /tmp
if [ $? -gt 0 ] ;then
	[ $isPL -eq 1 ] && echo "błąd rozpakowania archiwum, koniec" || echo "error extracting archive, end"
	exit 1
else
	[ $isPL -eq 1 ] && echo "Archiwum rozpakowane" || echo "Archive extracted"
	rm -f /tmp/listakanalow.zip
fi

pyVer=`python -c "import sys;print(sys.version_info.major)"`

if [ $pyVer -eq 2 ];then
	[ $isPL -eq 1 ] && echo "Wykryto system z python2" || echo "Found system using python2"
else
	[ $isPL -eq 1 ] && echo "Wykryto system z python3" || echo "Found system using python3"
fi

if [ -e /etc/enigma2 ];then
	rm  -rf /etc/enigma2
	[ $isPL -eq 1 ] && echo "Skasowano starą wersję listy kanałów" || echo "Removed old version of channel list"
fi
mv -f /tmp/listakanalow/enigma2 /etc/
if [ $? -gt 0 ] ;then
	[ $isPL -eq 1 ] && echo "błąd instalacji listy kanałów, koniec" || echo "error installing channel list, end"
	exit 1
else
	[ $isPL -eq 1 ] && echo "Lista kanałów zainstalowana" || echo "Channel list installed"
	rm -fr /tmp/listakanalow
fi
[ $isPL -eq 1 ] && echo "KONIEC - przeładuj teraz E2" || echo "END - reload E2"
sync
