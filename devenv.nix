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

  packages = [ pkgs.git ];

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
