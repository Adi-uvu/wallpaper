#!/bin/bash

ROOT_UID=0
DEST_DIR=""
DESKTOP_ENV=""

# Funkcja do wykrywania środowiska graficznego
detect_desktop_env() {
  case "$XDG_CURRENT_DESKTOP" in
    "GNOME" | "X-Cinnamon" | "Budgie" | "Budgie:GNOME" | "Unity")
      DESKTOP_ENV="GTK"
      ;;
    "KDE" | "Lxqt")
      DESKTOP_ENV="QT"
      ;;
    "Cutefish" | "Cutefish")
      DESKTOP_ENV="fish"
      ;;
    "xfce" | "XFCE")
      DESKTOP_ENV="xfce"
      ;;
    "MATE" | "MATE")
      DESKTOP_ENV="mate"
      ;;
    "Unity" | "Unity:Unity7:ubuntu")
      DESKTOP_ENV="-ubuntu-unity"
      ;;
    "Ukui" | "UKUI")
      DESKTOP_ENV="ukui"
      ;;
    *)
      echo "Nie mozna wykryc srodowiska graficznego GTK lub QT..."
      exit 1
      ;;
  esac
}

# Wykrywanie protokołu środowiska graficznego
detect_desktop_env

# Wykonywanie protokołów na podstawie wykrytego środowiska
# prorokół GTK
if [ "$DESKTOP_ENV" = "GTK" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/backgrounds"
    cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
    DEST_DIR="/usr/share/gnome-background-properties"
    cp -rT main $DEST_DIR
    echo "Pliki zostaly pomyslnie skopiowane (protokol GTK)."
  fi
# prorokół QT
elif [ "$DESKTOP_ENV" = "QT" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/wallpapers"
    cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
    echo "Pliki zostaly pomyslnie skopiowane... (protokol QT)."
  fi
# prorokół Cutefish qt
elif [ "$DESKTOP_ENV" = "fish" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/backgrounds/cutefishos"
    cp -r wallpaper-0.3.24/* "$DEST_DIR/"
    echo "Pliki zostaly pomyslnie skopiowane... (protokol Fish[QT])."
  fi
# prorokół xfce4
elif [ "$DESKTOP_ENV" = "xfce" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/xfce4/backdrops"
    cp -r wallpaper-0.3.24/* "$DEST_DIR/"
    echo "Pliki zostaly pomyslnie skopiowane... (protokol XFCE[GTK])."
  fi
# prorokół MATE
elif [ "$DESKTOP_ENV" = "mate" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/backgrounds"
    cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
    DEST_DIR="/usr/share/mate-background-properties"
    cp -rT main $DEST_DIR
    echo "Pliki zostaly pomyslnie skopiowane... (protokol GTK)."
  fi
# prorokół UbuntuUnity
elif [ "$DESKTOP_ENV" = "ubuntu-unity" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/backgrounds/ubuntu-unity"
    cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
    DEST_DIR="/usr/share/gnome-background-properties"
    cp -rT main $DEST_DIR
    echo "Pliki zostaly pomyslnie skopiowane... (protokol GTK)."
  fi
# prorokół UKUI
elif [ "$DESKTOP_ENV" = "ukui" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    DEST_DIR="/usr/share/backgrounds"
    cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
    DEST_DIR="/usr/share/ukui-background-properties"
    cp -rT main $DEST_DIR
    echo "Pliki zostaly pomyslnie skopiowane... (protokol UKUI[QT])."
  fi
# prorokół Nie obslugiwane
else
  echo "Nieobsługiwane srodowisko graficzne."
  exit 1
fi
