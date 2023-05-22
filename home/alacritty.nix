{ config, pkgs, ... }:
  let
    bindKey = key: mods: action: mode: {
      inherit key mods action mode;
    };

  in {
    home.sessionVariables.TERMINAL = "${config.programs.alacritty.package}/bin/alacritty";

    programs.alacritty = {
      enable = true;
      package = pkgs.unstable.alacritty;

      settings = {
        env.term = "xterm-256color";

        window = {
          dimensions = {
            columns = 0;
            lines = 0;
          };

          padding = {
            x = 1;
            y = 1;
          };

          dynamic_title = true;
          dynamic_padding = false;

          decorations = "full";
        };

        scrolling = {
          history = 100000;
          multiplier = 1;
        };

        # TODO: fontconfig
        # font = {};

        draw_bold_text_with_bright_colors = true;

        debug = {
          render_time = false;
          persistent_logging = false;
        };

        # TODO: theme
        # colors = {};

        indexed_colors = [];

        bell = {
          animation = "EaseOutExpo";
          duration = 0;
        };

        background_opacity = 1.0;

        mouse = {
          double_click.threshold = 300;
          triple_click.threshold = 300;

          faux_scrolling_lines = 1;

          hide_when_typing = false;

          hints = {
            launcher = "firefox";
            modifiers = "Control";
          };
        };

        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>";
          save_to_clipboard = true;
        };

        mouse_bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];

        cursor = {
          style = {
            shape = "Block";
            blinking = "On";
          };
          unfocused_hollow = true;
        };

        live_config_reload = true;

        # TODO: Set shell.
        # shell.program = "/bin/zsh";

        key_bindings = [
          (bindKey "PageUp" "Shift" "ScrollPageUp" "~Alt")
          (bindKey "PageDown" "Shift" "ScrollPageDown" "~Alt")
          (bindKey "Home" "Shift" "ScrollToTop" "~Alt")
          (bindKey "End" "Shift" "ScrollToBottom" "~Alt")
          (bindKey "Copy" "" "Copy" "")
          (bindKey "Paste" "" "Paste" "")
          (bindKey "Equals" "Control" "IncreaseFontSize" "")
          (bindKey "Minus" "Control" "DecreaseFontSize" "")
          (bindKey "Key0" "Control" "ResetFontSize" "")
        ];
      };
    };
  }