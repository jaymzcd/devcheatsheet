# Setting up new Macbook

Breakdown of what I did and how and from where when setting up the "new" macbook
after a few years of using the other one and having not used my own (since Aude
uses it). This is to document my current working setup properly for once.

Another goal with this is to get things working cleanly that have been hacked
together over time. Generally clear our some collected cruft. Try to install a
lot less applications I never use and make use of stuff that was already there
just a bit hidden (e.g. using `jupyter` notebooks instead of one off tooling).

# Install homebrew

Pretty much the first thing to kick everything else off:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

# Software installation

## Brew / CLI Packages

Mainly actual work applications

```
tmux exa docker-compose awscli node tig fasd direnv pyenv gpg pgcli p7zip
doxygen diff-so-fancy git-gui most ripgrep unrar jq watch fswatch
```

Usually useful to have for more general stuff

```
nmap httpie graphviz graphicsmagick csvkit cloc elinks mtr owasp-zap ffmpeg
```

For fun

```
cowsay lolcat figlet
```

## Casks to install:

Core stuff for general work and day to day.  _Insomnia_ here is a rest/graphql
client instead of postman) and _not_ the "disable sleep" tool!

```
sublime-text google-chrome avibrazil-rdm contexts iterm2 reggy retroarch
keepassxc karabiner-elements docker spotify slack vlc menumeters spectacle
google-backup-and-sync licecap obs whatsapp skim transmission mactex lyx bitbar
selfcontrol awscli ngrok calibre disk-inventory-x tunnelblick 1password insomnia
android-file-transfer haptickey session-manager-plugin
```

Others for fun, maybe depending on situation/need:

```
blender magicavoxel gzdoom steam gimp inkscape libreoffice firefox gifsicle
android-platform-tools
```

## Other applications

Manual due to licenses being out of date:

* keyboard-maestro  # (version 8: https://www.stairways.com/main/download)
* alfred  # (version 3: https://www.alfredapp.com/help/v3/)
* bettertouchtool  # (version 2: https://folivora.ai/downloads)
* dash  # (version 4: https://kapeli.com/downloads/v4/Dash.zip)

These aren't in Cask:

* Audacity

From the App Store itself:

* Pages, Numbers, iMovie, Keynote
* MindNode
* Pixelmator

## Fonts

Need to tap these and then I mainly use Fira Code these days in everything:

```sh
brew tap homebrew/cask-fonts
brew cask install font-fira-code font-fira-mono-for-powerline
```

# To try this time fresh

* Using docker instead of local services for the likes of postgres, nginx
* getting mypy/python path stuff working properly in sublime

## Things to reconsider now

* [afloat](https://github.com/rwu823/afloat) - was using for transparancy but
  nearly never used it

# Setting up Sublime

Set to open up all text content instead of TextEdit by default:
https://apple.stackexchange.com/questions/123833/replace-text-edit-as-the-default-text-editor/123834#123834

```sh
defaults write com.apple.LaunchServices/com.apple.launchservices.secure \
    LSHandlers -array-add \
    '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'
```

* Install _Package control_ using built-in menu option
* Set theme to: _ayu-dark_
* Set color scheme to: _dark-material_

Copy any non-repo project files to `~/Documents/sublime-projects/`.

✋ Need to work out how to get this playing nice with pyenv/virtualenv installs
when running particular projects. This is mainly for CodeIntel and MyPy.

## Formatter setup

Need to copy the settings and edit paths for formatters. Not too sure how to
get this to properly play nice with pyenv so have use the system version for
now:

```
/usr/bin/pip3 install --user black
```

This then installs here: `/Users/jaymz/Library/Python/3.7/bin/black` which
can then be set as the executable path within the settings. That then works.

<https://packagecontrol.io/packages/Formatter>

We use single quotes by default but black prefers double. To avoid this use
`--skip-string-normalization` but I can't get Formatter to work by passing
this as `"args": [...]` in the setting. Instead modify the config. These are
located at:

` ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/formatter.assets/config/`

For the `black.toml` file:

```ini
[tool.black]
line-length = 88
skip-string-normalization = true
```

I also installed http://prettier.io/ via `npm install -g prettier` and then
just set the path to that in fromatter. Then disabled the rest. I used the
sample config from the website for that and replaced the
`prettierrc.json` content with:

```json
{
  "arrowParens": "always",
  "bracketSpacing": true,
  "htmlWhitespaceSensitivity": "css",
  "insertPragma": false,
  "jsxBracketSameLine": false,
  "jsxSingleQuote": false,
  "printWidth": 80,
  "proseWrap": "preserve",
  "quoteProps": "as-needed",
  "requirePragma": false,
  "semi": true,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "es5",
  "useTabs": false,
  "vueIndentScriptAndStyle": false
}
```

## Distraction free mode

Some small tweaks to this, I don't use it so much so might try more.

```json
{
    "line_numbers": false,
    "gutter": true,
    "draw_centered": true,
    "wrap_width": 120,
    "word_wrap": false,
    "scroll_past_end": true
}
```

## Packges to install

For look & feel:

* ayu - using dark as theme
* darkmaterial (UI color scheme)

These are all used day to day and have been cut down over the years to just
often used essentials.

* advancenewfile
* filter lines
* git & gitgutter
* inc-dec-value
* sidebarenhancements - (provides locate in command palette)
* ~Anaconda  (instead of defunct SublimeCodeIntel)~
* Jedi! (for code intel, I tired LSP but could not get it to work properly)
* SublimeLinter
* trimmer
* wrap plus
* babel
* djanerio
* ColorHighlight - abandoned but the version available works fine

Not used so much but handy to have available rather than other tooling:

* emmet
* hexviewer
* PackageDev - for creating custom syntax definitions

## Emmet clash

Add the following user setting to avoid issues with `CMD+SHIFT+R`:

```
{
    // https://github.com/sergeche/emmet-sublime/issues/266#issuecomment-112030927
    "disabled_keymap_actions": "reflect_css_value, expand_abbreviation",
}
```

## SublimeLinter

~_Anaconda ships with essentially this all workign out fo the box so going to
invest in learning and configuring that. It includes complexity checks too.
Just need to configure with the same settings as I worked out here._~

After some painful playing around I prefer how SL3 does this and it's been
recently updated again. I ended up swapping back to it. Anaconda was not
running very reliably and a Github issue suggests the maintainer of it is
no longer interested (for some time).

* Install SublimeLinter-Flake8 and also `/usr/bin/pip3 install --user flake8`
Amend the settings to provide the location for the linter paths to check:

```json
// SublimeLinter Settings - User
{
    // Provide extra paths to be searched when locating system executables.

    "paths": {
        "linux": [],
        "osx": ["/Users/jaymz/Library/Python/3.7/bin/"],
        "windows": []
    },

    "linters": {

        // Configure Flake8 for complexity errors, ignore lambdas, binary break
        // * https://www.flake8rules.com/rules/W503.html
        // * https://www.flake8rules.com/rules/E731.html
        // * https://github.com/SublimeLinter/SublimeLinter-flake8/issues/83#issuecomment-365588410

        "flake8": {
            "@disable": false,
            "args": [
                "--max-complexity","5",
                "--max-line-length", "100",
                "--ignore", "E731,W503"
            ],
            "select": ""
        },

        // http://www.pydocstyle.org/en/5.0.1/error_codes.html

        "pydocstyle": {
            "@disable": false,
            "ignore": "D101,D102,D201,D202,D212",
        },

    }
}

```

## ~SublimeCodeIntel~

Similar to Black, need to install pip packages that will be available to Sublime.

<https://packagecontrol.io/packages/SublimeCodeIntel>

```sh
/usr/bin/pip3 install --user  CodeIntel
```

Ditching the sublime plugin itself which hasn't been updated in ages to use

[Anaconda](http://damnwidget.github.io/anaconda/) which is active.

##~ Anaconda Setup~

~Making use of my tweaks for linter/codeintel:~

```json

```

## Jedi

Settled on Jedi in the end!


# Setting up python in general

The system python on Catalina by default is 3.7 which isn't so bad and will likely
do fine for the majority of install work without resorting to maintaining several
site-packages and binaries. That said:

```
pyenv install 3.8.2
pyenv global 3.8.2
pip install --upgrade pip
pip install pipenv
```

```
pipenv --python 3.8.2 install --skip-lock
```

Using pipenv directly means no longer having to deal with virutalenv creation
by hand. It just works. Go with that these days!

## Jupyter configuration

* `jupyter nbextension enable --py widgetsnbextension` for `ipywidgets` in notebooks
* For _lab_ - enable extension manager and then install and await build of
  ipywidgets from the UI.

# VueJS

* https://cli.vuejs.org/guide/installation.html


```sh
npm install -g @vue/cli
```


# Shell

* create a `~/development/` folder and symlink `~/dev` to it as well

## Xcode

* `xcode-select --install` for build tools
* also open it up after install to ensure it's all good to go
* can then test doing a `pip install psycopg2` after install `postgresql`

## ohmyzsh

* https://github.com/ohmyzsh/ohmyzsh#basic-installation

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

This will install a basic `~/.zshrc` file if I've already copied my own I will
need to overwrite it again.

Install the autosuggest and syntax highlight plugins to `~/.oh-my-zsh/custom/plugins/`

* git clone https://github.com/zsh-users/zsh-autosuggestions.git
* git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

## Setup GPG for code signing

https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e

* quick way is to just copy the conf and keys to `~/.gnupg`
* when committing enter the relevant key password which should then store in the
  agent and keep in the background across boots
* TODO: agent setup

## Terminal configuration (general)

* SSH, ZSH, AWS, Git configs:
  * ~/.ssh/config, and any other keys required (check chmod `0600`)
  * ~/.zshrc
  * ~/.aws/credentials and ~/.aws/config
  * ~/.gitconfig (and other ~/.git... files)
  * ~/.tmux.conf
* tmux & powerline (see relevant sections)
* create new SSH key (`ssh-keygen`), backup..., add to github
* python & pyenv, nodejs, vue cli
* configuring iTerm defaults (see below)
* configuring native OSX terminal - not used so much so just minor tweaks:
  * background Tungsten, 80% opacity, 33% blur
  * use option as meta key
* check server access / private keys on remote hosts
* sync in some way the keepass key and db file for local passwords

## iTerm specifics

* set iterm profile to use firacode, enable ligatures
* keys: set left option to esc+
* terminal: set scrollback to unlimited
* window: set tiled background
* text: use thin strokes for anti-aliased text: always
* colors: set profile colors (for text) to _Tango Dark_
* colors: make sure "brighten bold text" is off
* text: enable subpixel rendering
* text: set cursor prompt to underline, blinking
* prefs > general > selection - enable "applications in terminal may access
  clipboard" & "double click smart"
* menu > iterm > install shell integration (with utils)

(Should dump this to a JSON file).

## Powerline

* https://powerline.readthedocs.io/en/master/installation/osx.html

```
pip install powerline-status
```

See above for fonts.

The `tmux.conf` file should source the correct path to the shell script, this
can be checked using `pip show powerline-status` and then copying the
_site-packages_ path.

# Creature Comforts for my UX in OS-X

These have developed over the years of using a Mac to become a large part of my
day-to-day routine work. Doing all this makes the system feel immediately familiar
again and minimizes disruption from any "missing" bits that I get to as I need

* window manager & spaces - create 4 of them:
  * desktop 1 for "work" related
  * full screen sublime/iTerm
  * desktop 2 for personal browser/maths
  * desktop 3 for spotify/media
  * desktop 4 for gaming/youtube/background
* keyboard maestro macros - install kmsync file
* setup folders (scratch, development, books etc) and symlinks (dev, tmp)
* wallpapers per screen - my usual 666 tiles + retro gaming
* dock cleanup - get rid of everything i dont use at all, this time set to have
  just the top 5 or so apps i use all the time pinned, then then "show recent
  apps in dock bar" so they appear on the left
* configure menu bar (via system prefs):
  * date & time: show date, display time with seconds
  * sound/output: enable "show volume in menu bar"
  * bluetooth: enable show in menu bar
* configure hot corners
  * top right: desktop
  * bottom right: screensaver
* enable zoom on scroll via accessibility
* trackpad
    * space swap to 4 finger swipe
    * scroll direction to natural
    * three instead of two fingers for forward/back pages (to avoid accidental
      back, better Google Spreadsheet UX)
    * enable app expose with four fingers down
    * expose foreground app to three/four swipe _down_
* global keyboard shortcuts
    * swap save vs clipboard screenshot defaults
    * "change space/fullscreen app" to ctl+opt+left/right
* network: set DNS addys to 8.8.8.8 / 8.8.4.4
* download and install fira code font (see fonts via cask)
* enable remote login (ssh) / sharing (as needed)
* network: set system hostname to `macha` or something relevant
* disable "automatically adjust brightness" in prefs
* install RDM & set resolution to 2560x1600
* Alfred
    * install backup preferences files
    * emoji pack
    * keyboard maestro integration
    * my custom searches (export and backup/restore)
    * features > snippets - enable auto expand by keyword (wasn't on when imported prefs)
* install dash docsets (minimum of python3, django, vuejs, react, html, css)
* add internet accounts for coconut, jaymzcd
* disable spotlight cmd+space shortcut in favour of alfred
* create a `scratch` folder on Desktop for dumping stuff
* swap shift+cmd+4 with ctrl+shift+cmd+4 for screenshot area to file/clipboard around
* disable ^ + down arrow in keyboard shortcuts for app control (used in tmux),
  change mission control shortcut to ^+opt+up
* set alert sound to _sosumi_
* install french dictionary
* bettertouchtool
  * corner click top right: lock screen
* [flying windows screensaver](http://looting.biz/misc/2007/05/21/flying-windows-screensaver-for-osx/)
  no longer works on catalina so go with "Drift" with spectrum color
* mission control: untick "automatically rearrange spaces"
* keyboard > text - untick "add full stop with double space"
* set haptickey to weak and "esc, f1, f2..." keys
* prefs > general
  * appearance: dark
  * accent: pink or purple
  * click scrollbar to jump 
  * recent items: 50
  * disable allow handoff (no iOS devices...)
* VLC:
  * uncheck "aspect ratio" to allow window resizing to any size

## Finder

* new finder windows show *home* folder by default
* show path bar, show status bar
* set the sidebar in finder to hide tags, network, airdrop. add home, /tmp,
  ~/dev
  folders as favs
* set finder to show harddrives and network drives on desktop
* set desktop icon size to 32x, label on right, show info, use stacks
* prefs: keep folders on top
* prefs: show all file extensions
* go to home folder and then view options: show library folder


## Slack

* Set theme to dark

## MenuMeters

* use "lime" for the green color, "strawberry" for red
* CPU: average of all cores (user: aqua, temp: tangerine)
* Disk: lights
* Memory: free/used totals, show paging
* Network: graph & throughput

## Hyper Key setup

* No need for this!
  ~https://brettterpstra.com/2017/06/15/a-hyper-key-with-karabiner-elements-full-instructions/~
* Need karabiner installed first and whitelisted in privacy
* Just open and go to complex modifications
* click add and use the given example of "change caps lock to ctrl/opt/meta/shft"
* disable "show icon in menubar"

# University stuff

With Lyx and LaTeX working ok the majority of this is all python based so should
be straightfoward by the time I get to it and just involve a new `pipenv install`.

* Copy/clone my openuni-notes folder into `documents`
* create a virtualenv and install python packages
* check I can open and render the latest Lyx TMA files and run recent jupyter
  notebooks (✅)
* copy over lyx preferences
* set jupyter lab theme to dark (via view menu)


# Retroarch setup 👾

## Cores

Open up load core, then install and then pretty much these always.

* SNES: Snes9x current
* Arcade: Mame
* GB/GBC: Gamebatte
* GBA: mgba
* PS1: Bettle PSX
* PSP: ppspp
* Nintendo DS: dsemu
* NES: nestopia
* TurboGrafx: Bettle
* Megadrive: picodrive
* Commodore 64: Vice
* N64: whatever available

Copy over roms to `~/Documents/roms` and then set that as the filebrowser
directory by default. Set the global shader to `crt-lottes-fast`.

For DooM:

```sh
cd ~/Library/Application\ Support
ln -s ~/Documents/roms/Doom gzdoom
```
