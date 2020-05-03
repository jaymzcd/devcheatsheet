cheatsheet do
  title 'Dev Cheat Sheet'
  docset_file_name 'dev'
  keyword 'dev'

  introduction <<END_INTRO
  A cheat sheet of useful things I do for development and commands, shortcuts
  and so on to make use of over time.

  I have remapped some of the default keybindings that I use a lot which is
  partly why I̕ʾve created this. Any command starting with a `;` is typically
  a [KeyboardMaestro (KM)](https://keyboardmaestro.com/) macro via a
  [_typed string trigger_](https://wiki.keyboardmaestro.com/trigger/Typed_String).

  Where a command involves `HYPER` this uses KarbinerElements to set
 `CMD+CTRL+SHIFT+OPTION` as a "new" control key. I tend to use this to provide
 "first class" shortcuts that are unlikley to clash with any existing ones.
 These very often trigger KM macros.

END_INTRO

  category do
    id 'Sublime Shortcuts'

    entry do
      command 'CTRL + -'
      command 'CTRL + SHIFT + -'
      name 'Jump back / forward to last cursor location (even across files)'
    end

    entry do
      command 'CMD + SHIFT + R'
      name 'Jump to a symbol across the project'
    end

    entry do
      command 'OPTION + F'
      name '**Jedi**: Find uses'
    end

    entry do
      command 'OPTION + D'
      name '**Jedi**: Show docstring'
    end

    entry do
      command 'OPTION + G'
      name '**Jedi**: Goto definition'
    end

    entry do
      command 'OPTION + A'
      name '**SublimeLinter**: Show errors'
    end

    entry do
      command 'HYPER + T'
      name 'Run a test'

      notes <<END_NOTE
      This runs a macro within KeyboardMaestro that:

      1. Selects the current text under the cursor
      1. Copies the _relative_ path to the current file for the project
      1. Prompts for any changes to the default arguments for `pytest`
      1. Optionally enable a coverage report for another path
      1. Sets the clipboard to the full command we'll need to run for this test
      1. Swaps to iTerm
      1. Pastes in the clipboard

      An example of the output:

      ```sh
      DJANGO_DB_USER=postgres \\
      ptw -n -c invoicing/tests/test_send_email_events.py -- \\
      --pdb -s  -k test_send_creates_email
      ```
END_NOTE
    end

    entry do
      command 'openstaged'
      command 'stagedfiles'

      name 'Open staged files'
      notes <<END_NOTE

      ```sh
      alias stagedfiles='git diff --relative --name-only --staged | sort | uniq'
      alias openstaged='subl $(stagedfiles)'
      ```
END_NOTE
    end

    entry do
      command 'opencommit'
      command 'opencommits'
      command 'lastcommit'

      name 'Open the last commit files'
      notes <<END_NOTE

      ```sh
      function lastcommit {
          # Returns a list of files changed in the last $1 commits - useful for
          # getting back to work after branch changes
          local COMMITS=${1:-1};
          git log --pretty="format:" --name-only --relative -n$COMMITS | sort | uniq
      }

      function opencommits {
          subl $(lastcommit $1);
      }

      alias opencommit='subl $(lastcommit)'
      ```
END_NOTE
    end

    entry do
      command 'opensince'
      command 'commitssince'

      name 'Open the files changed since `master`'
      notes <<END_NOTE

      ```sh
      function commitssince {
          local BRANCH=${1:-master};
          git log --pretty='format:' --name-only --relative ${BRANCH}..HEAD | sort | uniq
      }

      alias opensince='subl $(commitssince)'
      ```

END_NOTE
    end

    entry do
      command 'openmatching'
      name 'Open matching (.py) files'
      notes <<END_NOTE
      ```sh
      function openmatching {
          if [ $# -eq 0 ]; then
              exit;
          fi

          local EXTENSION=${2:-.py};
          subl $(find . -path "*$1*" -name "*$EXTENSION" -print0);
      }
      ```
END_NOTE
    end

  end


  category do
    id 'General macros & shortcuts'

    entry do
      command 'HYPER + B'
      name '**Chrome** create a branch name from JIRA issue'
      notes <<END_NOTE
      This is a KM macro to run a Javascript on the page (assumes it's a JIRA
      issue) and then extract the name of the ticket. This then gets "slugifyed"
      to a suitable name for a git branch that includes the ticket ID at the start.

      To finish off with it puts this into the clipboard and then switches to iTerm.

      ```javascript
      function get_branch_name() {

          var summary = document.getElementById('summary-val').innerText;
          var issue = document.getElementById('key-val').innerText;
          var detail = summary.toLowerCase().replace(/[^\w\s]/g, '').replace(/\s{2,}/, ' ').replace(/\s/g, '-');
          var branch_name =  issue + '-' + detail;

          branch_name = branch_name.substring(0, 64); // Keep Ali Happy ™

          if (branch_name.slice(-1) == '-') {
            branch_name = branch_name.substring(0, branch_name.length - 1);
          }

          return branch_name;
      }

      get_branch_name()
      ```
END_NOTE
    end

    entry do
      command ';pt'
      name '**Shell** Prepare a squash commit or PR title message'
      notes <<END_NOTE
      The `currentticket` is specific to our JIRA naming and assumes I am working
      on a branch that starts with the ticket ID as the first 9 characters (like
      `COCO-1234`).

      This is then used to prompt (via KM) for input with:

      1. An emoji for prefixing
      1. The ticket ID extracted from branch name
      1. The component being worked on (such as core or aggregation)
      1. A summary

      ```sh
      alias currentticket="currentbranch | cut -c1-9 | tr -d '\\n'"
      ```

      Resulting in something like:

      _🐛 COCO-9310: Invoicing: Fix admin key error_

END_NOTE
  end

    entry do
      command 'HYPER + U'
      name 'Extract a UUID from the currently selected text'
      notes <<END_NOTE
      This is simply a regex ran via KM:

      ```sh
      .*(\w{8}-\w{4}-\w{4}-\w{4}-\w{12}).*
      ```

      Any match is then put into the clipboard.

END_NOTE
    end

  end

  category do
    id 'Jupyter'

    entry do
      command '%autoreload'
      command ';autoreload'

      name 'Autoreloading of modules'

      notes <<END_NOTE

      The [`%autoreload` magic command](https://ipython.org/ipython-doc/stable/config/extensions/autoreload.html)
      will reload modules once itʾs been loaded.
      I use the `;autoreload` macro to write out in any session:

      ```python
      %load_ext autoreload
      %autoreload 2
      ```
END_NOTE
    end

    entry do
      name 'Show all cell output'
      command 'ast_node_interactivity'

      notes <<END_NOTE
      By default Jupyter will only output the last result from a cell. The way
      I work with my maths tends to involve several steps I want to just output
      using `Markdown(...)` so I find it helpful to see all of these per cell.

      ```python
      from IPython.core.interactiveshell import InteractiveShell
      InteractiveShell.ast_node_interactivity = "all"
      ```
END_NOTE
    end

  end

  category do
    id 'Testing'

    entry do
      command '(;)ptw'
      name 'Watch a test'
      notes <<END_NOTE

      Uses a KeyboardMaestro macro to output:

      ```sh
      DJANGO_DB_USER=postgres ptw -n -c %Variable%Path%  -- %Variable%Flags% -k %Variable%Pattern%
      ```

      If _with coverage_ is selected then it includes the `--cov*` options.
END_NOTE
    end

    entry do
      command 'coverage'
      name 'Coverage Reporting'
      notes <<END_NOTE

      Coverage reporting I tend to run via Pytest with the `pytest-cov` plugin.
      This is customized with the `coconut/.coveragerc` file and custom styling
      within `coconut/coconut/coverage.css`.

      Note that the `--cov` here should be in module import syntax, e.g.
      `invoicing.utils`.

      ```sh
      pytest
        invoicing/tests/test_send_email_events.py
        --cov-report=html:static/coverage/
        --cov=invoicing.utils
        --pdb -s
        -k test_send_creates_email
      ```

      After tests run using the `;ptw` you can get a report from the command
      line using `coverage report`.
END_NOTE
  end

  end

  category do
    id 'Git'

    entry do
      name 'Aliases'
      notes <<END_NOTE

      Since I spend most of my Git time in the command line these aliases save
      a bunch of time day to day.

      ```sh
      alias gp='git push'
      alias gb='git branch'
      alias gc='git checkout'
      alias gmsp='git commit -Sjaymz@jaymz.eu -am'
      alias gl='git log --decorate --oneline'
      alias gd='git diff --word-diff'
      alias gcl='git clone'
      alias grb='git rebase -i'
      alias gs='git stat'  # (see alias within `~/.gitconfig`)
      alias gpu='git pull'
      ```

      Less commonly used:

      ```sh
      alias gittagsbydate='git log --tags --simplify-by-decoration --pretty="format:%ai %d"'
      alias devheaddifflist='git diff --name-only develop..HEAD';
      ```
END_NOTE
    end

    entry do
      command 'rebaseonmaster'
      command 'rbm'
      name 'Rebase on master'
      notes <<END_NOTE

      Fetch current and rebase the current branch with master commits

      ```sh
      git fetch origin master:master; git rebase origin/master --gpg-sign=jaymz@jaymz.eu
      ```
END_NOTE
    end

    entry do
      command 'gig'
      command 'gtr'
      command 'showignored'
      command 'ignorediff'
      command 'trackdiff'

      name 'Ignoring and Tracking files temporarily'
      notes <<END_NOTE

      To deal with temporary changes I donʾt want to accidentally commit:

      ```sh
      alias gig='git update-index --assume-unchanged'
      alias gtr='git update-index --no-assume-unchanged'

      # Then to find these:
      alias showignored='git ls-files -v | egrep "^[hsmrck]" | cut -d\  -f2'
      alias ignorediff='gig `gd --name-only`'

      # And to retrack
      alias trackdiff='gtr `show_ignored`'
      ```
END_NOTE
    end

    entry do
      command 'gclastbranchmatching'
      command 'gclb'
      command 'lastbranches'
      command 'lb'
      command 'currentbranch'

      name 'Last branch matching'
      notes <<END_NOTE
      These are mainly used for jumping around between branches when working
      across features or bug fixing.

      ```sh
      function lastbranches {
          local COUNT=${1:-10};
          gb --sort=committerdate --format='%(refname:short)' | head -$COUNT
      }
      alias lb=lastbranches;

      function gclastbranchmatching {
          local COUNT=${2:-25};
          gc $(lastbranches $COUNT | grep -i $1)
      }
      alias gclb=gclastbranchmatching

      # Useful for scripts and prefilling commit messages
      alias currentbranch='git rev-parse --abbrev-ref HEAD'
      ```
END_NOTE
    end

    entry do
      command 'listnewcommitsbetweenbranches'
      name 'Commits across branches'
      notes <<END_NOTE
      Since we use cherry-picking to create release branches it can be sometimes
      helpful to see what _truely_ differs in terms of commit logs between
      branches which may have picked commits with different hashes.

      This uses a technique found on
      [StackOverflow](https://stackoverflow.com/questions/44512391/how-can-i-find-pending-commits-between-two-branches-excluding-already-cherry-pic).

      ```sh
      function listnewcommitsbetweenbranches {
          for commit in $(git cherry $1 $2 | egrep '^\+' | awk -F' ' '{print $2}'); do
              LOG=$(git --no-pager log --pretty=format:"HASH:%h AUTHOR:%aN SUBJECT:%s" -n1 $commit)
              echo $LOG;
          done
      }
      ```

      As an example of the output:

      ```sh
      $ listnewcommitsbetweenbranches origin/release/1.46.0 origin/release/1.47.0
      HASH:63541805d AUTHOR:Jaymz SUBJECT:Track user ID
      HASH:0d7bb1f45 AUTHOR:Jaymz SUBJECT:Remove XXX for now
      HASH:11b5daabe AUTHOR:Jaymz SUBJECT:Trap IntegrityError
      ```

END_NOTE
    end

    entry do
      command 'bm'
      name 'Find branch with last commit date'
      notes <<END_NOTE

      This finds branches matching a given input along with the last commit date.

      ```sh
        function bm {
            gb -a --sort=committerdate --format='%(refname:short): %(committerdate:iso8601)' | \\
            grep -i $1 | \\
            sed 's/origin\///' | \\
            sort | \\
            uniq;
        }
        ```
END_NOTE
    end

  end

  category do
    id 'PDB & Debugging'

    entry do
      command 'pp'
      name 'Pretty print variable'
      notes 'This will output anything with newlines or key: values'
    end

    entry do
      command 'args'
      name 'Show arguments at this point'
      notes 'Dumps out the current functions arguments passed'
    end

    entry do
      command 'ipdb'
      command 'web_pdb'
      name 'Nicer debuggers'
      notes <<END_NOTE
      I typically use `ipdb` to drop into an ipython/juputer console but thereʾs
      also [`web_pdb`](https://github.com/romanvm/python-web-pdb) which gives a
      UI with watch variables and the like. I should try and use that more when
      doing a more complex bit of debugging.
END_NOTE
    end

  end

  category do
    id 'Terminals & Tmux'

    entry do
      command 'capture-pane'
      name '**tmux** Capture scrollback to file'
      notes <<END_NOTE

      Here the _1000_ signified the number lines back to copy. Use `^B` to
      enable the command input and then:

      ```sh
      :capture-pane -S -1000
      :save-buffer ~/log.txt
      ```
END_NOTE
    end

    entry do
      command 'tc'
      command 'ta'
      command 'tk'
      command 'tw'
      command 'ts'
      name '**tmux** Session aliases'
      notes <<END_NOTE

      Some aliases to make creating/joining tmux sessions a little nicer.

      ```sh
      # Daily usage
      alias tc='tmux new -s'
      alias ta='tmux attach -t'
      alias ts='tmux list-sessions'

      # Useful - should use more!
      alias tw='tmux rename-window'

      # Not used as much but handy
      alias tk='tmux kill-session -t'
      alias tn='tmux rename-session'

      # Easier to do OPTION + UP/DOWN but useful for scripts
      alias tsw='tmux switch -t'
      ```
END_NOTE
    end

    entry do
      command 'CTRL + B, Q'
      command 'HYPER + P'

      name '**tmux** Focus pane'
      notes <<END_NOTE
      Iʾve been having issues with the "right" pane being selected when using my
      other `SHIFT + UP/DOWN` short cut. This involves typing the pane number that
      appears but it least focuses the relevant session then.
END_NOTE
    end

    entry do
      command 'OPTION + UP/DOWN'
      command 'CTRL + B, W'
      name '**tmux** Swap session'
      notes 'This will go through each running tmux session or let you pick from a menu'
    end

    entry do
      command 'CMD + ;'
      command 'CMD + SHIFT + :'
      name '**iTerm** Open command history'
      notes <<END_NOTE
      Opens a searchable history list from whatever was entered across any running
      terminal. This unfortunately does [not work](https://www.iterm2.com/documentation-shell-integration.html)
      but is worth remembering it exists.
END_NOTE
    end

    entry do
      command 'watch'
      command 'watch -n <secs>'
      name 'Repeat command at an interval'
    end

    entry do
      command 'fswatch [OPTS] <path>'
      command 'watchfile <path> <command>'
      name 'Repeat command on file system changes'
      notes <<END_NOTE

      This uses fswatch via HomeBrew to do something similar to watch but for a
      file. fswatch itself outputs the changed paths so for `watchfile` thereʾs
      some contortion to get it running.

      1. `-o` in fsatch ouputs the count of paths changed
      1. this is then piped into `xargs`
      1. `-n1` tells xargs to run the command _"once per passed argument"_
      1. [-I](https://unix.stackexchange.com/a/282416) removes the fswatch passed count

      ```sh
      function watchfile {
        fswatch -o $1 | xargs -n1 -I{} ${@:2};
      }
      ```

      Here the `${@:2}` returns all the arguments from after the second, i.e.
      if we run:

      ```sh
      watchfile dev.rb cheatset generate dev.rb
      ```

      Then `@:2` becomes _`cheatset generate dev.rb`_.

END_NOTE
    end

  end

  category do
    id 'Regular Expressions'

    entry do
      command '(?:)'
      name 'Non-capturing group'
      notes 'This will not return in `.group(n)` match objects. Useful for ignoring terms.'
    end

  end

  category do
    id 'grep, ripgrep & related'

    entry do
      command 'rg <PATTERN> -l'
      name 'Print files matching pattern'
      notes <<END_NOTE

      * `rg -i '(class|def) Invoice' -l`: find `class ...` or `def Invoice` case
        insensitively and just print the matching paths
END_NOTE
    end

    entry do
      command 'rg <PATTERN> -o -I'
      name 'Output only the matches'
      notes <<END_NOTE
      Here the flags mean:

      * `-o` output only match
      * `-I` no filename
      * `-N` no line number (but not needed when piping, typically)

      ```sh
      rg -thtml -i '(details|component).*html' -o -I | sort | uniq
      ```
END_NOTE
    end

    entry do
      command 'rg -t py -t html <PATTERN>'
      name 'Search Python _and_ HTML files for pattern'
    end

  end

  category do
    id 'Alfred Custom Searches'

    entry do
      command 'cf'
      name '**Confluence** search for {term}'
    end

    entry do
      command 'jr'
      name '**JIRA** Open issue COCO-{XXXX}'
    end

    entry do
      command 'js'
      name '**JIRA** search for {term}'
    end

    entry do
      command 'pr'
      name '**Github** open platform PR #{XXX}'
    end

    entry do
      command 'gh'
      name '**Github** search'
    end

    entry do
      command 'g'
      name '**Google** search'
    end

    entry do
      command 'ar'
      name '**Archive.Org**'
    end

    entry do
      command 'im'
      name '**Google** search images'
    end

    entry do
      command 'w'
      name '**Wikipedia** search'
    end

  end

  category do
    id 'AWS'
  end

  category do
    id 'Docker'
  end

  category do
    id 'Useful Python Libraries'

    entry do
      command 'colorama'
      name '[Color console output](https://github.com/tartley/colorama) using ascii escape codes'
      notes <<END_NOTE

      ```python
      from colorama import Fore, Back, Style
      print(Fore.RED + 'some red text')
      print(Back.GREEN + 'and with a green background')
      print(Style.DIM + 'and in dim text')
      print(Style.RESET_ALL)
      print('back to normal now')
      ```
END_NOTE
    end

  end

  category do
    id 'OS X specific'

    entry do
      command 'caffeinate'
      command 'caffeinate -t <secs>'
      name 'Avoid sleeping, this is basically a command line version of InsomniaX and ships with OS-X.'
    end

    entry do
      command 'pbcopy'
      command 'pbpaste'
      name 'Copy & paste buffer access from terminal'
    end

    entry do
      command 'OPTION + SHIFT + 6'
      command 'OPTION + SHIFT + 7'
      name 'Brightness down/up by 3 steps'
      notes 'Handled by a KM macro. I use this on macs with a touch bar.'
    end

    entry do
      command 'OPTION + SHIFT + 8'
      command 'OPTION + SHIFT + 9'
      name 'Volume down/up by 3 steps'
      notes 'Similar reasoning to the brightness shortcut.'
    end

  end

  category do
    id 'Media conversion'

    entry do
      name '**ffmpeg** extract slice of video'
    end

    entry do
      command 'ffmpeg -i <src> -c copy -an <dst>'
      name '**ffmpeg** _remove_ audo'
    end

    entry do
      command 'ffmpeg -i <src> -vn -acodec copy <dst.mp3>'
      name '**ffmpeg** _rip_ audo'
    end

    entry do
      command 'ffmpeg -i <src>  -vf scale=X:Y <dst>'
      name '**ffmpeg** resize video, where x, y are in pixels'
    end

    entry do
      command 'ffmpeg -i <src> -vf reverse <dst>'
      name '**ffmpeg** reverse video'
    end

    entry do
      name '**imagemagick** create animated GIF'
    end

    entry do
      name 'Compress animated GIF'
    end

    entry do
      name '**vlc** rip stream'
    end

  end

  notes <<END_NOTE

### Rationale

### History

END_NOTE

end
