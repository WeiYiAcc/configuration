{
  # 如果你想引用你的 GitHub/GitLab 访问令牌和其他秘密，请取消注释下一行
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  
  # secrets,
  config,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  # 定义不稳定的软件包集合
  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    jq
    killall
    lunarvim
    mosh
    neovim
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
    #begin
    solargraph
    #end

  ];

  # 定义稳定的软件包集合
  stable-packages = with pkgs; [
    # FIXME: 根据你使用的语言自定义这些稳定的软件包
    # FIXME: customize these stable packages to your liking for the languages that you use

    # key tools
    gh # for bootstrapping #用于引导
    just

    # core languages
    rustup
    go
    lua
    nodejs
  #  python3
    typescript
    ruby_3_1 #添加ruby
    rubocop #添加rubocop
    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf # 本地开发工具
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    ccls # c / c++
    gopls
    nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    nil # nix
    nodePackages.pyright

    # formatters and linters
    alejandra # nix
    black # python
    ruff # python
    deadnix # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
    sqlfluff
    tflint
    #begin
    pkgs.lazygit #lazygit installed
    #python311Packages.jupyter-core
    jupyter
    bundix
    yt-dlp
    #end
  ];
in {
  # 导入 nix-index 数据库模块
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  # 设置 home-manager 的状态版本
  home.stateVersion = "22.11";

  home = {
    # 设置用户名
    username = "${username}";
    # 设置用户主目录
    homeDirectory = "/home/${username}";

    # 设置编辑器环境变量
    sessionVariables.EDITOR = "lvim";
    # FIXME: set your preferred $SHELL # FIXME: 设置你喜欢的 $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
  };

  # 定义 home-manager 安装的软件包
  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: 你可以在这里添加任何不属于上述两个列表的软件包
    # FIXME: you can add anything else that doesn't fit into the above two lists in here 
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  # FIXME: 如果你想对 LunarVim 配置进行版本控制，请将其添加到此仓库的根目录并取消注释下一行
  # FIXME: if you want to version your LunarVim config, add it to the root of this repo and uncomment the next line
  # home.file.".config/lvim/config.lua".source = ./lvim_config.lua;

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    # 启用 nix-index 的 Zsh 集成
    nix-index.enableZshIntegration = true;
    # 启用 nix-index-database 的 comma 模块
    nix-index-database.comma.enable = true;

    # FIXME: 如果你不想使用 starship 提示符，请禁用它
    # FIXME: disable this if you don't want to use the starship prompt
    starship.enable = true;
    # 配置 starship 提示符
    starship.settings = {      
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };

    # FIXME: disable whatever you don't want
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    broot.enable = true;
    broot.enableZshIntegration = true;

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "weiyiacc"; # FIXME: set your git email
      userName = "weiyiacc@outlook.com"; #FIXME: set your git username
      extraConfig = {
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
        #     insteadOf = "https://gitlab.com";
        #   };
        # };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    # FIXME: This is my .zshrc - you can fiddle with it if you want
    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      history.size = 10000;
      history.save = 10000;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      history.ignoreSpace = true;
      historySubstringSearch.enable = true;

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];

      shellAliases = {
        "..." = "./..";
        "...." = "././..";
        cd = "z";
        gc = "nix-collect-garbage --delete-old";
        refresh = "source ${config.home.homeDirectory}/.zshrc";
        show_path = "echo $PATH | tr ':' '\n'";

        # FIXME: 如果你想添加更多 git 别名，请在这里添加
        # FIXME: add more git aliases here if you want them
        gapa = "git add --patch";
        grpa = "git reset --patch";
        gst = "git status";
        gdh = "git diff HEAD";
        gp = "git push";
        gph = "git push -u origin HEAD";
        gco = "git checkout";
        gcob = "git checkout -b";
        gcm = "git checkout master";
        gcd = "git checkout develop";

        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };

      envExtra = ''
        export PATH=$PATH:$HOME/.local/bin
      '';

      initExtra = ''
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^e' end-of-line
        bindkey '^w' forward-word
        bindkey "^[[3~" delete-char
        bindkey ";5C" forward-word
        bindkey ";5D" backward-word

        zstyle ':completion:*:*:*:*:*' menu select

        # Complete . and .. special directories
        zstyle ':completion:*' special-dirs true

        zstyle ':completion:*' list-colors ""
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

        # disable named-directories autocompletion
        zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

        # Use caching so that commands like apt and dpkg complete are useable
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

        # Don't complete uninteresting users
        zstyle ':completion:*:*:*:users' ignored-patterns \
                adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
                clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
                gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
                ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
                named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
                operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
                rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
                usbmux uucp vcsa wwwrun xfs '_*'
        # ... unless we really want to.
        zstyle '*' single-ignored complete

        # https://thevaluable.dev/zsh-completion-guide-examples/
        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        # mkcd is equivalent to takedir
        function mkcd takedir() {
          mkdir -p $@ && cd ''${@:$#}
        }

        function takeurl() {
          local data thedir
          data="$(mktemp)"
          curl -L "$1" > "$data"
          tar xf "$data"
          thedir="$(tar tf "$data" | head -n 1)"
          rm "$data"
          cd "$thedir"
        }

        function takegit() {
          git clone "$1"
          cd "$(basename ''${1%%.git})"
        }

        function take() {
          if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
            takeurl "$1"
          elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
            takegit "$1"
          else
            takedir "$@"
          fi
        }

        WORDCHARS='*?[]~=&;!#$%^(){}<>'

        # fixes duplication of commands when using tab-completion
        export LANG=C.UTF-8
      '';
    };
    
  };
}
