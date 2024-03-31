{ lib, config, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.locale;
in {
  options.JenSeReal.system.locale = with types; {
    enable = mkEnableOption "Whether or not to use the variables set.";
    default_locale = mkOpt str "en_US.UTF-8" "The language to use";
    extra_locale = mkOpt str "de_DE.UTF-8" "The locale to use";
  };

  config = mkIf cfg.enable {
    i18n.extraLocaleSettings = {
      defaultLocale = cfg.default_locale;
      LC_ADDRESS = cfg.extra_locale;
      LC_IDENTIFICATION = cfg.extra_locale;
      LC_MEASUREMENT = cfg.extra_locale;
      LC_MONETARY = cfg.extra_locale;
      LC_NAME = cfg.extra_locale;
      LC_NUMERIC = cfg.extra_locale;
      LC_PAPER = cfg.extra_locale;
      LC_TELEPHONE = cfg.extra_locale;
      LC_TIME = cfg.extra_locale;
    };
  };
}
