{ stdenv, fetchFromGitHub, glib, zip, unzip, gnome3, systemd, webkitgtk }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-syncthing-${version}";
  version = "git-2021-04-11";

  src = fetchFromGitHub {
    owner = "jaystrictor";
    repo = "gnome-shell-extension-syncthing";
    rev = "37e590d5fe4bef40cad1492fa664f841dbc6a980";
    sha256 = "1wbyqs03ml6kjjf4x2vmwp6w5jphf59r27n5qr7i5gvqimbby4ki";
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
