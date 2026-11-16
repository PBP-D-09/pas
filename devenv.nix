{
  pkgs,
  ...
}:

{
  android = {
    enable = true;
    flutter.enable = true;
    platforms.version = [ "36" ];
    buildTools.version = [ "36.0.0" ];
  };

  packages = [
    pkgs.git
    # Needed to build/run the Linux desktop target (`flutter build linux`).
    pkgs.gtk3
    pkgs.pkg-config
  ];

  scripts.flutter-format.exec = ''
    dart format lib test
  '';

  scripts.flutter-check.exec = ''
    flutter analyze
    flutter test
  '';

  enterShell = ''
    echo "SustainaBowl Flutter environment"
  '';

  enterTest = ''
    flutter analyze
    flutter test
  '';
}
