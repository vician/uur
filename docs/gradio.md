## Download
```bash
wget -O /tmp/uur/gradio/gradio.6.0.1.tar.gz https://github.com/haecker-felix/gradio/archive/v6.0.1.tar.gz
```
## Build
```bash
cd /tmp/uur/gradio/gradio-6.0.1/
mkdir -p builddir;
meson builddir --prefix=/usr
```
## Install
```bash
cd /tmp/uur/gradio/gradio-6.0.1/
sudo ninja -C builddir install
```
