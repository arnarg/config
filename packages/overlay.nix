final: prev: {
  anytype = prev.callPackage ./anytype {};
  kbct = prev.callPackage ./kbct {};
  plex-exporter = prev.callPackage ./plex-exporter {};
  whitesur-gtk-theme = prev.callPackage ./whitesur-gtk-theme {};
  whitesur-icon-theme = prev.callPackage ./whitesur-icon-theme {};
  whitesur-kde = prev.callPackage ./whitesur-kde {};

  myTmuxPlugins = prev.lib.recurseIntoAttrs (prev.callPackage ./tmux-plugins {});

  vimPlugins = prev.vimPlugins // {
    nvim-treesitter = prev.vimPlugins.nvim-treesitter.overrideAttrs (oa: {
      postPatch = (oa.postPatch or "") + ''
        mkdir -p queries/todotxt
        cat <<EOF > queries/todotxt/highlights.scm
        (done_task) @comment
        (task (priority) @keyword)
        (task (date) @comment)
        (task (kv) @comment)
        (task (project) @string)
        (task (context) @type)
        EOF
      '';
    });
  };
}
