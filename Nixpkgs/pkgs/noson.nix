{ stdenv, lib, mkDerivation, fetchFromGitHub, cmake
, libpulseaudio
, flac
, qtgraphicaleffects
, qtquickcontrols2
, qtbase
}:

mkDerivation rec {
  pname = "noson";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "janbar";
    repo = "noson-app";
    rev = version;
    hash = "sha256-DhPYyOdvEpAf38JREWqHuIyheeC6S6YQxXo9BYKJZbs=";
  };

  nativeBuildInputs = [
  ];

  buildInputs = [
    cmake
    libpulseaudio
    flac
    qtbase
    qtgraphicaleffects
    qtquickcontrols2
  ];

  # The noson-gui binary is not found by wrapQtApps
  dontWrapQtApps = true;
  preFixup = ''
    echo "wrapping $out/lib/noson/noson-gui"
    wrapQtApp "$out/lib/noson/noson-gui"
  '';

  meta = with lib; {
    description = "SONOS controller for Linux";
    homepage = "https://janbar.github.io/noson-app/";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ callahad ];
  };
}
