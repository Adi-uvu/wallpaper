#!/bin/bash

ROOT_UID=0
DEST_DIR=""
DESKTOP_ENV=""

# Kolory ANSI do tęczowego tekstu
RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RESET='\033[0m'  # Resetowanie koloru

# Tabela kolorów w pionie
COLORS=($RED $ORANGE $YELLOW $GREEN $CYAN $BLUE $PURPLE)

# ASCII Art
TEXT=(
"  /$$$$$$        /$$ /$$                                      "
" /$$__  $$      | $$|__/                                      "
"| $$  \\ $$  /$$$$$$$ /$$       /$$   /$$ /$$    /$$ /$$   /$$"
"| $$$$$$$$ /$$__  $$| $$      | $$  | $$|  $$  /$$/| $$  | $$"
"| $$__  $$| $$  | $$| $$      | $$  | $$ \\  $$/$$/ | $$  | $$"
"| $$  | $$| $$  | $$| $$      | $$  | $$  \\  $$$/  | $$  | $$"
"| $$  | $$|  $$$$$$$| $$      |  $$$$$$/   \\  $/   |  $$$$$$/"
"|__/  |__/ \\_______/|__/      \\______/     \\_/     \\______/"
"                       |______/                               "
)

# Wyświetlanie ASCII Art z kolorami pionowymi
for (( i=0; i<${#TEXT[@]}; i++ )); do
  LINE="${TEXT[$i]}"
  for (( j=0; j<${#LINE}; j++ )); do
    CHAR="${LINE:$j:1}"
    COLOR=${COLORS[$((j % ${#COLORS[@]}))]}
    echo -ne "${COLOR}${CHAR}${RESET}"
  done
  echo ""
done

# Sprawdzanie, czy skrypt jest uruchamiany jako root
if [ "$UID" -ne "$ROOT_UID" ]; then
  echo "Ten skrypt wymaga uprawnien roota. Użyj sudo do uruchomienia skryptu."
  exit 1
fi

# Wykrywanie środowiska graficznego
detect_desktop_env

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
    "Unity:Unity7:ubuntu")
      DESKTOP_ENV="ubuntu-unity"
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

# Wykonywanie operacji na podstawie wykrytego środowiska
if [ "$DESKTOP_ENV" = "GTK" ]; then
  DEST_DIR="/usr/share/backgrounds"
  cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
  DEST_DIR="/usr/share/gnome-background-properties"
  cp -rT main/gtk $DEST_DIR
  echo "Pliki zostały pomyślnie skopiowane (protokół GTK)."
elif [ "$DESKTOP_ENV" = "QT" ]; then
  DEST_DIR="/usr/share/wallpapers"
  cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
  echo "Pliki zostały pomyślnie skopiowane... (protokół QT)."
elif [ "$DESKTOP_ENV" = "fish" ]; then
  DEST_DIR="/usr/share/backgrounds/cutefishos"
  cp -r wallpaper-0.3.24/* "$DEST_DIR/"
  echo "Pliki zostały pomyślnie skopiowane... (protokół Fish[QT])."
elif [ "$DESKTOP_ENV" = "xfce" ]; then
  DEST_DIR="/usr/share/xfce4/backdrops"
  cp -r wallpaper-0.3.24/* "$DEST_DIR/"
  echo "Pliki zostały pomyślnie skopiowane... (protokół XFCE[GTK])."
elif [ "$DESKTOP_ENV" = "mate" ]; then
  DEST_DIR="/usr/share/backgrounds"
  cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
  DEST_DIR="/usr/share/mate-background-properties"
  cp -rT main/gtk $DEST_DIR
  echo "Pliki zostały pomyślnie skopiowane... (protokół GTK)."
elif [ "$DESKTOP_ENV" = "ubuntu-unity" ]; then
  DEST_DIR="/usr/share/backgrounds/ubuntu-unity"
  cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
  DEST_DIR="/usr/share/gnome-background-properties"
  cp -rT main/unity $DEST_DIR
  echo "Pliki zostały pomyślnie skopiowane... (protokół GTK)."
elif [ "$DESKTOP_ENV" = "ukui" ]; then
  DEST_DIR="/usr/share/backgrounds"
  cp -pr wallpaper-0.3.24 $DEST_DIR/wallpaper-0.3.24
  DEST_DIR="/usr/share/ukui-background-properties"
  cp -rT main/gtk $DEST_DIR
  echo "Pliki zostały pomyślnie skopiowane... (protokół UKUI[QT])."
else
  echo "Nieobsługiwane środowisko graficzne."
  exit 1
fi

# Sprawdzanie opcji -rm lub -remove
if [ "$1" = "-rm" ] || [ "$1" = "-remove" ]; then
  if [ "$UID" -eq "$ROOT_UID" ]; then
    # Usuwanie skopiowanych plików
    if [ -d "/usr/share/backgrounds/wallpaper-0.3.24" ]; then
      rm -rf /usr/share/backgrounds/wallpaper-0.3.24
      echo "Usunięto pliki z /usr/share/backgrounds/"
    fi
    if [ -d "/usr/share/gnome-background-properties" ]; then
      rm -rf /usr/share/gnome-background-properties/wallpaper-0.3.24
      echo "Usunięto pliki z /usr/share/gnome-background-properties/"
    fi
    if [ -d "/usr/share/wallpapers" ]; then
      rm -rf /usr/share/wallpapers/wallpaper-0.3.24
      echo "Usunięto pliki z /usr/share/wallpapers/"
    fi
    # Dodaj inne ścieżki w razie potrzeby
  else
    echo "Ten skrypt wymaga uprawnień roota. Użyj sudo do uruchomienia skryptu."
    exit 1
  fi
fi