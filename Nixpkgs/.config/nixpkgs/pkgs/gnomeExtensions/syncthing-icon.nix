{ stdenv, fetchFromGitHub, glib, zip, unzip, gnome3, systemd, webkitgtk }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-syncthing-${version}";
  version = "2020-04-03";

  src = fetchFromGitHub {
    owner = "jaystrictor";
    repo = "gnome-shell-extension-syncthing";
    rev = "3d4a50fe1c7262af6dd8ba1920963289e4b29e71";
    sha256 = "0zyyxdg0jw308hdi6xsjks17z6xxayw9k2i8l9lwwy97mhk7jmlh";
  };

  nativeBuildInputs = [ glib zip unzip ];
  buildInputs = [ gnome3.gjs webkitgtk systemd ];

  patches = [
    ./fix-syncthing-icon.patch
  ];

  postPatch = ''
    substituteInPlace src/systemd.js \
      --replace "/bin/systemctl" "${systemd}/bin/systemctl"
    substituteInPlace src/extension.js \
      --replace "gjs" "${gnome3.gjs}/bin/gjs"
    substituteInPlace src/webviewer.js \
      --subst-var-by webkitPath "${webkitgtk}/lib/girepository-1.0"
  '';

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    substituteInPlace install.sh --replace '$HOME/.local/' '$out/'
    ./install.sh
  '';

  meta = with stdenv.lib; {
    description = "Display SyncThing status icon in top bar";
    license = licenses.gpl3;
    maintainers = with maintainers; [ callahad ];
    homepage = https://github.com/jaystrictor/gnome-shell-extension-syncthing;
  };
}
