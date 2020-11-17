How to install this overlay
----------------------------

### Layman
```sh
layman -o 'https://github.com/qix67/gentoo-overlay/raw/master/repositories.xml' -f -a qix67
```

Use a package from this overlay instead of gentoo official package
------------------------------------------------------------------

Example for cantata

1. mask gentoo package
```sh
echo "media-sound/cantata::gentoo" >> /etc/portage/package.mask
```

2. re-emerge package
```
emerge -1 media-sound/cantata
```

Packages provided by this overlay
---------------------------------

* app-misc/g15daemon : include uinput patch

* dev-db/pgadmin3-abdulyadi: AbdulYadi's pgadmin3 fork (support recent PostgreSQL versions)

* media-gfx/qcad: open source 2D CAD software

* media-sound/cantata: disable animation, disable mpd database refresh confirmation, enable alternate row colors on several lists

* net-misc/socat: add VSOCK support
* net-misc/tigervnc: remove overlay message "Press ... to open the context menu"

* net-p2p/qbittorrent: include fix for issue #11908 (reverse proxy)

* sci-electronics/kicad: use wxgtk3.0-gtk2 instead of wxgtk3.0-gtk3

* sys-boot/uefitool: version 56_alpha

* www-client/firefox: disable urlbar "Click Selects All" feature, session is restored on current workspace instead of workspace where firefox were closed

* x11-libs/gtk+: gtk3 with all gtk3-mushrooms patches.

* x11-misc/fbpanel: inverse direction of wheel desktop change
