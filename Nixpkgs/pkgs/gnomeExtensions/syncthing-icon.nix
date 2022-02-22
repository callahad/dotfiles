{ stdenv, lib, fetchFromGitHub, glib, zip, unzip, gjs, systemd, webkitgtk }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-syncthing-${version}";
  version = "git-2021-04-11";

  src = fetchFromGitHub {
    owner = "jaystrictor";
    repo = "gnome-shell-extension-syncthing";
    rev = "v33";
    sha256 = "sha256-B+RbObiK2PC7PiM20s7DrFoshopecw1RZg2uSRagv7M=";
  };

  nativeBuildInputs = [ glib zip unzip ];
  buildInputs = [ gjs webkitgtk systemd ];

  patches = [
    ./fix-syncthing-icon.patch
  ];

  postPatch = ''
    substituteInPlace src/systemd.js \
      --replace "/bin/systemctl" "${systemd}/bin/systemctl"
    substituteInPlace src/extension.js \
      --replace "gjs" "${gjs}/bin/gjs"
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

  meta = with lib; {
    description = "Display SyncThing status icon in top bar";
    license = licenses.gpl3;
    maintainers = with maintainers; [ callahad ];
    homepage = https://github.com/jaystrictor/gnome-shell-extension-syncthing;
  };
}
