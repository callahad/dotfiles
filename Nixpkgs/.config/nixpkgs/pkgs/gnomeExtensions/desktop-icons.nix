{ stdenv, fetchFromGitLab, meson, ninja, python3, glib, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-desktop-icons-${version}";
  version = "20.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World%2FShellExtensions";
    repo = "desktop-icons";
    rev = "${version}";
    sha256 = "02in0dcjjpf6fvi87xxdbhv36ghsgy7ii4sd00hcxjvzr683mixi";
  };

  nativeBuildInputs = [ meson ninja python3 glib ];
  buildInputs = [ gnome3.nautilus ];

  prePatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  patches = [
    ./fix-desktop-icons.patch
  ];

  postPatch = ''
    substituteInPlace prefs.js \
      --subst-var-by gschemasDir "${placeholder "out"}/share/gsettings-schemas/${name}/glib-2.0/schemas" \
      --subst-var-by gschemasDirNautilus "${gnome3.nautilus}/share/gsettings-schemas/${gnome3.nautilus.name}/glib-2.0/schemas"
  '';

  meta = with stdenv.lib; {
    description = "Display desktop icons in GNOME";
    license = licenses.gpl3;
    maintainers = with maintainers; [ callahad ];
    homepage = https://gitlab.gnome.org/World/ShellExtensions/desktop-icons;
  };
}
