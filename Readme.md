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
