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

* app-emulation/libvirt : modify USE flag 'virt-network' not to depend on all routing/bridge/firewall tools. Add USE flag 'virt-network-filter' which works like original 'virt-network' USE flag

* app-misc/g15daemon : include uinput patch

* app-office/libreoffice : add USE flag 'qt5' to compile with qt5 but without kde

* dev-db/pgadmin3-abdulyadi: AbdulYadi's pgadmin3 fork (support recent PostgreSQL versions)

* dev-embedded/teensyduino-bin: teensyduino binary package

* media-gfx/brscan5-bin: SANE drivers from Brother for brscan5 compatible models
* media-gfx/qcad: open source 2D CAD software

* media-sound/cantata: disable animation, disable mpd database refresh confirmation, enable alternate row colors on several lists

* net-misc/socat: add VSOCK support
* net-misc/tigervnc: remove overlay message "Press ... to open the context menu"

* net-print/hplip: add USE flag 'zeroconf' to compile with or without avahi

* net-p2p/qbittorrent: include fix for issue #11908 (reverse proxy)

* sci-electronics/kicad: use wxgtk3.0-gtk2 instead of wxgtk3.0-gtk3

* sys-boot/uefitool: version 56_alpha

* www-client/firefox: disable urlbar/searchbar "Click Selects All" feature, session is restored on current workspace instead of workspace where firefox were closed. Add USE flag "fake-buildid" to disable firefox 'restart required' after upgrade.

* x11-libs/gtk+: gtk3 with all gtk3-mushrooms patches and gtktreeview alternate row colorization (treeview row.odd/treeview row.even)

* x11-misc/fbpanel: inverse direction of wheel desktop change

* x11-themes/adwaita-icon-theme: same as original gentoo package but without adwaita cursors.

