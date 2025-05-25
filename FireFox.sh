#!/bin/bash

if command -v firefox >/dev/null 2>&1; then
  echo "Firefox already exists"
else
  echo ""
  echo "Downloading firefox..."
  cd ~/Downloads
  wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=zh-CN" -O firefox.tar.bz2
  tar xJf firefox.tar.bz2
  sudo mv firefox /opt/firefox
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
  echo 'export PATH=/usr/local/bin:$PATH' >>~/.bashrc
  source ~/.bashrc
fi

if command -v geckodriver >/dev/null 2>&1; then
  echo "geckodriver already exists"
else
  wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz
  tar -xvzf geckodriver-*.tar.gz
  chmod +x geckodriver
  sudo mv geckodriver /usr/local/bin/
fi
