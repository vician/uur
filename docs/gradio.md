## Download
```
wget -O gradio.uur https://github.com/haecker-felix/gradio/archive/v6.0.1.tar.gz
```
```
## Build
```
    cd ${archivedir};
    mkdir -p $builddir;
    meson $builddir --prefix=/usr
```
## Install
```
    cd ${archivedir};
    sudo ninja -C $builddir install
```
