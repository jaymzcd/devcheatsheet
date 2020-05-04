cheatsheet do
  title 'Dev & Math Cheat Sheet'
  docset_file_name 'dev'
  keyword 'dev'
  style <<END_CSS
  table.colors td {
    padding: 0.5rem;
  }
  table.colors {
    min-width: 500px;
    max-width: 90%;
  }
END_CSS

  introduction <<END_INTRO
  A cheat sheet of useful things I do for development and commands, shortcuts
  and so on to make use of over time. This stuff mainly covers:

  * my professional life which is mainly full stack work with a focus towards
    backends written in Python. I tend to cover everything from debugging,
    front end work in React/Vue/vanilla, scripting, ops - really anything
    technical in a variety of languages, platforms and styles.
  * my mathematics work. Iʾve recently completed a BSc with the Open University
    and am now working towards a Masters with a 50-50 split across applied and
    pure disciplines. I do a lot of my study work using Python (sympy, scipy etc)
    and typeset everything in LaTeX (using [Lyx](https://www.lyx.org/))
  * my personalizations to defaults on operating systems, shells etc. I try to
    aim for consistency so heavily lean on cross platform tooling or modified
    key bindings and command line utilities so that I have roughly the same
    tool chain be it Mac, Linux, Android, Windows or whatever else.

  I have remapped some of the default key bindings that I use a lot which is
  partly why I̕ʾve created this. Any command starting with a `;` is typically
  a [KeyboardMaestro (KM)](https://keyboardmaestro.com/) macro via a
  [_typed string trigger_](https://wiki.keyboardmaestro.com/trigger/Typed_String).

  Where a command involves `HYPER` this uses
  [KarbinerElements](https://karabiner-elements.pqrs.org/) to set
 `CMD+CTRL+SHIFT+OPTION` as a "new" control key. I tend to use this to provide
 "first class" shortcuts that are unlikely to clash with any existing ones.
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

    entry do
      command 'Markdown("...")'
      command 'Image(url="")'
      command 'HTML("...")'

      name 'Include HTML, LaTeX, Images and more'
      notes <<END_NOTE
      You can include any HTML you want within the markdown section. Useful
      for coloring in titles.

      ```python

      from IPython.display import Image, HTML, Markdown

      Markdown("""
      ## <font color="dodgerblue">Q1a</font>

      This is a lead in section that will be a paragraph within the Jupyter cell.

      * A formula: $\\frac{dy}{dx} = exp^{i\\pi}$
      * This is _not_ as important <small>(in theory)</small>

      Image(url="http://jaymz.eu/fancy.png")

      """)
      ```

      Would give a blue title and then output in a bullet list a MathJax rendered
      expression. This is useful when writing out full solutions in a single
      cell with a "narrative" style.
END_NOTE
    end

    entry do
      command 'pd.set_option'
      name '**Pandas** Show all table rows (or a custom limit)'
      notes <<END_NOTE

      ```python
      import pandas as pd

      pd.set_option('display.height', 1000)
      pd.set_option('display.max_rows', 500)
      pd.set_option('display.max_columns', 500)
      pd.set_option('display.width', 1000)
      ```

END_NOTE
    end

    entry do
      command 'interact'
      name 'Simple interactive slider'
      notes <<END_NOTE
      See below about how to ensure that `ipywidgets` is actually enabled.

      ```python
      from ipywidgets import interact

      def f(x):
          return x
      interact(f, x=10);
      ```
END_NOTE
    end

    entry do
      command 'widgets.Button'
      command 'widgets.Text'
      command 'widgets.Output'
      command 'display'
      command 'clear_output'

      name 'Create a clearable input widget that updates the display'
      notes <<END_NOTE

      This requires [`ipywidgets`](https://ipywidgets.readthedocs.io/en/latest/).
      This recepie is a bit beyond a trival "input/output" and provides
      a counter and display of multiple items which can then be cleared.

      ⚠️ This requires that the widgets extension has been enabled first!

      For notebooks:

      ```sh
      jupyter nbextension enable --py widgetsnbextension
      ```

      For Jupyter _Lab_ first
      [enable the experimental manager](https://jupyterlab.readthedocs.io/en/stable/user/extensions.html#using-the-extension-manager)
      and then just click install (probably the top package listed). Then build
      and wait until complete.

      The basic technique is:

      1. Create a `widgets.<Input>` item with relevant defaults
      1. Add a `widgets.Button` to control this
      1. Add a callback for the button and bind using `.on_click`
      1. Combine the widgets as needed with an `ui = widgets.HBox(...)`
      1. Create an output if desired with `widgets.Output`
      1. Render it to the cell using `display(ui, output)

      This method allows for the cell output buffer to be controlled and changed
      easily (e.g. clearing it).

      ```python
      # Example of an interactive widget layout that can take
      # user input and parse it into an equation, do things and
      # render back output in a useful way.

      import ipywidgets as widgets

      from IPython.display import display, Markdown
      from sympy.parsing.sympy_parser import parse_expr
      from sympy import latex, diff

      input_fn = widgets.Text(
          value='1+x+x**2',
          placeholder='Type something',
          description='Function',
      )

      go_btn = widgets.Button(description="Go")
      clear_btn = widgets.Button(description="Clear")

      output = widgets.Output()
      count = 0

      def go_callback(widget):
          global count
          fn = parse_expr(input_fn.value)
          count += 1

          with output:
              display(Markdown("""
      ## Expression {count}

      * Input: ${input}$
      * Derivative: ${derivative}$
              """.format(count=count,
                         input=latex(fn),
                         derivative=latex(diff(fn, 'x')))))

      def clear_callback(widget):
          with output:
              output.clear_output()


      go_btn.on_click(go_callback)
      clear_btn.on_click(clear_callback)

      box = widgets.HBox([input_fn, go_btn, clear_btn])
      display(box, output)
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
      I typically use `ipdb` to drop into an ipython/jupyter console but thereʾs
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
      command '> /dev/null 2>&1'
      command ';null'
      name 'Redirect stdout/stderr to `/dev/null`'
      notes 'Never quite remember this exactly right, hence the KM text macro'
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

    entry do
      command 'touch file.{txt,html,doc}'
      command 'cp file.{txt,py}'
      name '**Shell** Curly braces expanded'
      notes <<END_NOTE
      The items within the braces are expanded and iterated over so in the `touch`
      command example what happens is we get a `file.txt`, `file.html` etc created.
      The copy example effectively says `cp file.txt file.py`.

      Lots more info available on [Linux.com](https://www.linux.com/topic/desktop/all-about-curly-braces-bash/).

      Very handy when making several directories at once or creating a lot of
      `__init__.py` files for folders where you might instinctively do
      a `for; do...`

      ```sh
      touch {admin,models,views,tests}/__init__.py
      mkdir -p {static,media/uploads}

      tree -d
      .
      ├── media
      │   └── uploads
      └── static

      3 directories
      ```
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

    entry do
      command 'rom'
      name '**WowRoms** search'
    end

    entry do
      command 'hn'
      name '**HackerNews** search via [Agolia](https://hn.algolia.com)'
    end

    entry do
      command 'so'
      name '**StackOverflow** search'
    end

  end

  category do
    id 'AWS'

    entry do
      name '**CLI** Credentials'
    end

    entry do
      name '**CLI** Session Manager'
    end

    entry do
      name '**EC2** instances'
    end

    entry do
      command '...| filter @field ~=/<pattern>/'
      name '**Cloudwatch** log filtering'
    end

  end

  category do
    id 'Docker'

    entry do
      name 'Shell on container'
    end

    entry do
      name 'Login'
    end

  end

  category do
    id 'Flexbox'

    entry do
      command 'flex'
      name 'Display'
    end

    entry do
      command 'justify-content'
      name 'Justifying'
    end

    entry do
      command 'align-items'
      name 'Alignment'
    end

    entry do
      command 'd-flex'
      command 'justify-content-<key>'
      command 'align-items-<key>'
      name 'Bootstrap 4 Grids'
    end

  end

  category do
    id 'CSS'

    entry do
      name 'Animations'
    end

    entry do
      name 'Gradients'
    end

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
    id 'SQL'

    entry do
      name 'Windowing'
    end

  end

  category do
    id 'Math: LaTeX & Symbolic Algebra'

    entry do
      command 'detexify'
      name '**Latex** Finding a symbol'
      notes <<END_NOTE
      * [Detexify](https://detexify.kirelabs.org/classify.html) - draw in browser
      * [CTAN Comprehensive List](http://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf) - full list as a PDF document
      * [Overleaf main symbols](https://www.overleaf.com/learn/latex/List_of_Greek_letters_and_math_symbols) - the main ones that might be useful, along with Greek
END_NOTE
    end

    entry do
      command '\partial'
      command '\frac{dx}{dy}'
      command 'y^\prime'
      name '**Latex** Derivatives'
    end

    entry do
      command '\align'
      name '**Latex** Alignment'
    end

    entry do
      command '[as|to]_terms'
      command '[as|to]_func'

      name '**Sympy** Calculus with implicit functions'
      notes <<END_NOTE

      This is just a recepie I tend to do a lot when working with Functionals
      as part of the M820 advanced calculus module. Since the symbolic algebra
      within Sympy works with explict functions when differentiating but most
      of the typical work involves using the implict form, _F(x,y,y')_ itʾs
      convenient to be able to do these manipulations and jump back and forth
      without having to write lots of substitutions each time.

      ```python
      from sympy import symbols, Function, diff

      x, y, dy, d2y = symbols('x y y^\\prime y^{\\prime\\prime}')
      Yx = Function('Y')(x)
      DYx = diff(Yx)
      D2Yx = diff(DYx)

      to_func = {
          x: x,
          y: Yx,
          dy: DYx,
          d2y: D2Yx,
      }
      as_func = lambda e: e.subs(to_func)

      # Unsure how to get around the need to do the d2y term first
      to_terms = {v: k for k, v in to_func.items()}
      as_terms = lambda e: e.subs({D2Yx: d2y}).subs(to_terms)

      # Combine into a wrapper so we can go from an expression with implicit functions
      # to actual functions, do our transformation and then return back to implict terms
      apply = lambda fn, e: as_terms(fn(as_func(e)))

      # Eg:
      F = dy * cos(x)
      df = apply(diff, F)

      # Results in :
      # `-y^\\prime*sin(x) + y^{\\prime\\prime}*cos(x)`

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

  category do
    id 'Colors'

    entry do
      name '**X11** Pinks'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>
<tr style="background:pink;color:black">
<td><code>Pink</code></td>
<td><code>FF&nbsp;C0&nbsp;CB</code></td>
<td><code>255&nbsp;192&nbsp;203</code>
</td></tr>
<tr style="background:lightpink;color:black">
<td><code>LightPink</code></td>
<td><code>FF&nbsp;B6&nbsp;C1</code></td>
<td><code>255&nbsp;182&nbsp;193</code>
</td></tr>
<tr style="background:hotpink;color:black">
<td><code>HotPink</code></td>
<td><code>FF&nbsp;69&nbsp;B4</code></td>
<td><code>255&nbsp;105&nbsp;180</code>
</td></tr>
<tr style="background:deeppink;color:black">
<td><code>DeepPink</code></td>
<td><code>FF&nbsp;14&nbsp;93</code></td>
<td><code>255&nbsp;&nbsp;20&nbsp;147</code>
</td></tr>
<tr style="background:palevioletred;color:black">
<td><code>PaleVioletRed</code></td>
<td><code>DB&nbsp;70&nbsp;93</code></td>
<td><code>219&nbsp;112&nbsp;147</code>
</td></tr>
<tr style="background:mediumvioletred;color:black">
<td><code>MediumVioletRed</code></td>
<td><code>C7&nbsp;15&nbsp;85</code></td>
<td><code>199&nbsp;&nbsp;21&nbsp;133</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Reds'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:lightsalmon;color:black">
<td><code>LightSalmon</code></td>
<td><code>FF&nbsp;A0&nbsp;7A</code></td>
<td><code>255&nbsp;160&nbsp;122</code>
</td></tr>
<tr style="background:salmon;color:black">
<td><code>Salmon</code></td>
<td><code>FA&nbsp;80&nbsp;72</code></td>
<td><code>250&nbsp;128&nbsp;114</code>
</td></tr>
<tr style="background:darksalmon;color:black">
<td><code>DarkSalmon</code></td>
<td><code>E9&nbsp;96&nbsp;7A</code></td>
<td><code>233&nbsp;150&nbsp;122</code>
</td></tr>
<tr style="background:lightcoral;color:black">
<td><code>LightCoral</code></td>
<td><code>F0&nbsp;80&nbsp;80</code></td>
<td><code>240&nbsp;128&nbsp;128</code>
</td></tr>
<tr style="background:indianred;color:black">
<td><code>IndianRed</code></td>
<td><code>CD&nbsp;5C&nbsp;5C</code></td>
<td><code>205&nbsp;&nbsp;92&nbsp;&nbsp;92</code>
</td></tr>
<tr style="background:crimson;color:black;color:black">
<td><code>Crimson</code></td>
<td><code>DC&nbsp;14&nbsp;3C</code></td>
<td><code>220&nbsp;&nbsp;20&nbsp;&nbsp;60</code>
</td></tr>
<tr style="background:firebrick;color:black">
<td><code>Firebrick</code></td>
<td><code>B2&nbsp;22&nbsp;22</code></td>
<td><code>178&nbsp;&nbsp;34&nbsp;&nbsp;34</code>
</td></tr>
<tr style="background:darkred;color:black">
<td><code>DarkRed</code></td>
<td><code>8B&nbsp;00&nbsp;00</code></td>
<td><code>139&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:red;color:black">
<td><code>Red</code></td>
<td><code>FF&nbsp;00&nbsp;00</code></td>
<td><code>255&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Oranges'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:orangered;color:black">
<td><code>OrangeRed</code></td>
<td><code>FF&nbsp;45&nbsp;00</code></td>
<td><code>255&nbsp;&nbsp;69&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:tomato;color:black">
<td><code>Tomato</code></td>
<td><code>FF&nbsp;63&nbsp;47</code></td>
<td><code>255&nbsp;&nbsp;99&nbsp;&nbsp;71</code>
</td></tr>
<tr style="background:coral;color:black">
<td><code>Coral</code></td>
<td><code>FF&nbsp;7F&nbsp;50</code></td>
<td><code>255&nbsp;127&nbsp;&nbsp;80</code>
</td></tr>
<tr style="background:darkorange;color:black">
<td><code>DarkOrange</code></td>
<td><code>FF&nbsp;8C&nbsp;00</code></td>
<td><code>255&nbsp;140&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:orange;color:black">
<td><code>Orange</code></td>
<td><code>FF&nbsp;A5&nbsp;00</code></td>
<td><code>255&nbsp;165&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Yellows'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:yellow;color:black">
<td><code>Yellow</code></td>
<td><code>FF&nbsp;FF&nbsp;00</code></td>
<td><code>255&nbsp;255&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:lightyellow;color:black">
<td><code>LightYellow</code></td>
<td><code>FF&nbsp;FF&nbsp;E0</code></td>
<td><code>255&nbsp;255&nbsp;224</code>
</td></tr>
<tr style="background:lemonchiffon;color:black">
<td><code>LemonChiffon</code></td>
<td><code>FF&nbsp;FA&nbsp;CD</code></td>
<td><code>255&nbsp;250&nbsp;205</code>
</td></tr>
<tr style="background:lightgoldenrodyellow;color:black">
<td><code style="margin-right:1em;">LightGoldenrodYellow</code>&nbsp;</td>
<td><code>FA&nbsp;FA&nbsp;D2</code></td>
<td><code>250&nbsp;250&nbsp;210</code>
</td></tr>
<tr style="background:papayawhip;color:black">
<td><code>PapayaWhip</code></td>
<td><code>FF&nbsp;EF&nbsp;D5</code></td>
<td><code>255&nbsp;239&nbsp;213</code>
</td></tr>
<tr style="background:moccasin;color:black">
<td><code>Moccasin</code></td>
<td><code>FF&nbsp;E4&nbsp;B5</code></td>
<td><code>255&nbsp;228&nbsp;181</code>
</td></tr>
<tr style="background:peachpuff;color:black">
<td><code>PeachPuff</code></td>
<td><code>FF&nbsp;DA&nbsp;B9</code></td>
<td><code>255&nbsp;218&nbsp;185</code>
</td></tr>
<tr style="background:palegoldenrod;color:black">
<td><code>PaleGoldenrod</code></td>
<td><code>EE&nbsp;E8&nbsp;AA</code></td>
<td><code>238&nbsp;232&nbsp;170</code>
</td></tr>
<tr style="background:khaki;color:black">
<td><code>Khaki</code></td>
<td><code>F0&nbsp;E6&nbsp;8C</code></td>
<td><code>240&nbsp;230&nbsp;140</code>
</td></tr>
<tr style="background:darkkhaki;color:black">
<td><code>DarkKhaki</code></td>
<td><code>BD&nbsp;B7&nbsp;6B</code></td>
<td><code>189&nbsp;183&nbsp;107</code>
</td></tr>
<tr style="background:gold;color:black">
<td><code>Gold</code></td>
<td><code>FF&nbsp;D7&nbsp;00</code></td>
<td><code>255&nbsp;215&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Browns'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:cornsilk;color:black">
<td><code>Cornsilk</code></td>
<td><code>FF&nbsp;F8&nbsp;DC</code></td>
<td><code>255&nbsp;248&nbsp;220</code>
</td></tr>
<tr style="background:blanchedalmond;color:black">
<td><code>BlanchedAlmond</code></td>
<td><code>FF&nbsp;EB&nbsp;CD</code></td>
<td><code>255&nbsp;235&nbsp;205</code>
</td></tr>
<tr style="background:bisque;color:black">
<td><code>Bisque</code></td>
<td><code>FF&nbsp;E4&nbsp;C4</code></td>
<td><code>255&nbsp;228&nbsp;196</code>
</td></tr>
<tr style="background:navajowhite;color:black">
<td><code>NavajoWhite</code></td>
<td><code>FF&nbsp;DE&nbsp;AD</code></td>
<td><code>255&nbsp;222&nbsp;173</code>
</td></tr>
<tr style="background:wheat;color:black">
<td><code>Wheat</code></td>
<td><code>F5&nbsp;DE&nbsp;B3</code></td>
<td><code>245&nbsp;222&nbsp;179</code>
</td></tr>
<tr style="background:burlywood;color:black">
<td><code>Burlywood</code></td>
<td><code>DE&nbsp;B8&nbsp;87</code></td>
<td><code>222&nbsp;184&nbsp;135</code>
</td></tr>
<tr style="background:tan;color:black">
<td><code>Tan</code></td>
<td><code>D2&nbsp;B4&nbsp;8C</code></td>
<td><code>210&nbsp;180&nbsp;140</code>
</td></tr>
<tr style="background:rosybrown;color:black">
<td><code>RosyBrown</code></td>
<td><code>BC&nbsp;8F&nbsp;8F</code></td>
<td><code>188&nbsp;143&nbsp;143</code>
</td></tr>
<tr style="background:sandybrown;color:black">
<td><code>SandyBrown</code></td>
<td><code>F4&nbsp;A4&nbsp;60</code></td>
<td><code>244&nbsp;164&nbsp;&nbsp;96</code>
</td></tr>
<tr style="background:goldenrod;color:black">
<td><code>Goldenrod</code></td>
<td><code>DA&nbsp;A5&nbsp;20</code></td>
<td><code>218&nbsp;165&nbsp;&nbsp;32</code>
</td></tr>
<tr style="background:darkgoldenrod;color:black">
<td><code>DarkGoldenrod</code></td>
<td><code>B8&nbsp;86&nbsp;0B</code></td>
<td><code>184&nbsp;134&nbsp;&nbsp;11</code>
</td></tr>
<tr style="background:Peru;color:black">
<td><code>Peru</code></td>
<td><code>CD&nbsp;85&nbsp;3F</code></td>
<td><code>205&nbsp;133&nbsp;&nbsp;63</code>
</td></tr>
<tr style="background:chocolate;color:black">
<td><code>Chocolate</code></td>
<td><code>D2&nbsp;69&nbsp;1E</code></td>
<td><code>210&nbsp;105&nbsp;&nbsp;30</code>
</td></tr>
<tr style="background:saddlebrown;color:black">
<td><code>SaddleBrown</code></td>
<td><code>8B&nbsp;45&nbsp;13</code></td>
<td><code>139&nbsp;&nbsp;69&nbsp;&nbsp;19</code>
</td></tr>
<tr style="background:sienna;color:black">
<td><code>Sienna</code></td>
<td><code>A0&nbsp;52&nbsp;2D</code></td>
<td><code>160&nbsp;&nbsp;82&nbsp;&nbsp;45</code>
</td></tr>
<tr style="background:brown;color:black">
<td><code>Brown</code></td>
<td><code>A5&nbsp;2A&nbsp;2A</code></td>
<td><code>165&nbsp;&nbsp;42&nbsp;&nbsp;42</code>
</td></tr>
<tr style="background:maroon;color:black">
<td><code>Maroon</code></td>
<td><code>80&nbsp;00&nbsp;00</code></td>
<td><code>128&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0</code>
</td></tr>

</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Greens'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:darkolivegreen;color:black">
<td><code>DarkOliveGreen</code></td>
<td><code>55&nbsp;6B&nbsp;2F</code></td>
<td><code>&nbsp;85&nbsp;107&nbsp;&nbsp;47</code>
</td></tr>
<tr style="background:olive;color:black">
<td><code>Olive</code></td>
<td><code>80&nbsp;80&nbsp;00</code></td>
<td><code>128&nbsp;128&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:olivedrab;color:black">
<td><code>OliveDrab</code></td>
<td><code>6B&nbsp;8E&nbsp;23</code></td>
<td><code>107&nbsp;142&nbsp;&nbsp;35</code>
</td></tr>
<tr style="background:yellowgreen;color:black">
<td><code>YellowGreen</code></td>
<td><code>9A&nbsp;CD&nbsp;32</code></td>
<td><code>154&nbsp;205&nbsp;&nbsp;50</code>
</td></tr>
<tr style="background:limegreen;color:black">
<td><code>LimeGreen</code></td>
<td><code>32&nbsp;CD&nbsp;32</code></td>
<td><code>&nbsp;50&nbsp;205&nbsp;&nbsp;50</code>
</td></tr>
<tr style="background:lime;color:black">
<td><code>Lime</code></td>
<td><code>00&nbsp;FF&nbsp;00</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;255&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:lawngreen;color:black">
<td><code>LawnGreen</code></td>
<td><code>7C&nbsp;FC&nbsp;00</code></td>
<td><code>124&nbsp;252&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:chartreuse;color:black">
<td><code>Chartreuse</code></td>
<td><code>7F&nbsp;FF&nbsp;00</code></td>
<td><code>127&nbsp;255&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:greenyellow;color:black">
<td><code>GreenYellow</code></td>
<td><code>AD&nbsp;FF&nbsp;2F</code></td>
<td><code>173&nbsp;255&nbsp;&nbsp;47</code>
</td></tr>
<tr style="background:springgreen;color:black">
<td><code>SpringGreen</code></td>
<td><code>00&nbsp;FF&nbsp;7F</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;255&nbsp;127</code>
</td></tr>
<tr style="background:mediumspringgreen;color:black">
<td><code style="margin-right:2em;">MediumSpringGreen</code>&nbsp;</td>
<td><code>00&nbsp;FA&nbsp;9A</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;250&nbsp;154</code>
</td></tr>
<tr style="background:lightgreen;color:black">
<td><code>LightGreen</code></td>
<td><code>90&nbsp;EE&nbsp;90</code></td>
<td><code>144&nbsp;238&nbsp;144</code>
</td></tr>
<tr style="background:palegreen;color:black">
<td><code>PaleGreen</code></td>
<td><code>98&nbsp;FB&nbsp;98</code></td>
<td><code>152&nbsp;251&nbsp;152</code>
</td></tr>
<tr style="background:darkseagreen;color:black">
<td><code>DarkSeaGreen</code></td>
<td><code>8F&nbsp;BC&nbsp;8F</code></td>
<td><code>143&nbsp;188&nbsp;143</code>
</td></tr>
<tr style="background:mediumaquamarine;color:black">
<td><code>MediumAquamarine</code></td>
<td><code>66&nbsp;CD&nbsp;AA</code></td>
<td><code>102&nbsp;205&nbsp;170</code>
</td></tr>
<tr style="background:mediumseagreen;color:black">
<td><code>MediumSeaGreen</code></td>
<td><code>3C&nbsp;B3&nbsp;71</code></td>
<td><code>&nbsp;60&nbsp;179&nbsp;113</code>
</td></tr>
<tr style="background:seagreen;color:black">
<td><code>SeaGreen</code></td>
<td><code>2E&nbsp;8B&nbsp;57</code></td>
<td><code>&nbsp;46&nbsp;139&nbsp;&nbsp;87</code>
</td></tr>
<tr style="background:forestgreen;color:black">
<td><code>ForestGreen</code></td>
<td><code>22&nbsp;8B&nbsp;22</code></td>
<td><code>&nbsp;34&nbsp;139&nbsp;&nbsp;34</code>
</td></tr>
<tr style="background:green;color:black">
<td><code>Green</code></td>
<td><code>00&nbsp;80&nbsp;00</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;128&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
<tr style="background:darkgreen;color:black">
<td><code>DarkGreen</code></td>
<td><code>00&nbsp;64&nbsp;00</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;100&nbsp;&nbsp;&nbsp;0</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Cyans'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:aqua;color:black">
<td><code>Aqua</code></td>
<td><code>00&nbsp;FF&nbsp;FF</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;255&nbsp;255</code>
</td></tr>
<tr style="background:cyan;color:black">
<td><code>Cyan</code></td>
<td><code>00&nbsp;FF&nbsp;FF</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;255&nbsp;255</code>
</td></tr>
<tr style="background:lightcyan;color:black">
<td><code>LightCyan</code></td>
<td><code>E0&nbsp;FF&nbsp;FF</code></td>
<td><code>224&nbsp;255&nbsp;255</code>
</td></tr>
<tr style="background:paleturquoise;color:black">
<td><code>PaleTurquoise</code></td>
<td><code>AF&nbsp;EE&nbsp;EE</code></td>
<td><code>175&nbsp;238&nbsp;238</code>
</td></tr>
<tr style="background:aquamarine;color:black">
<td><code>Aquamarine</code></td>
<td><code>7F&nbsp;FF&nbsp;D4</code></td>
<td><code>127&nbsp;255&nbsp;212</code>
</td></tr>
<tr style="background:turquoise;color:black">
<td><code>Turquoise</code></td>
<td><code>40&nbsp;E0&nbsp;D0</code></td>
<td><code>&nbsp;64&nbsp;224&nbsp;208</code>
</td></tr>
<tr style="background:mediumturquoise;color:black">
<td><code>MediumTurquoise</code></td>
<td><code>48&nbsp;D1&nbsp;CC</code></td>
<td><code>&nbsp;72&nbsp;209&nbsp;204</code>
</td></tr>
<tr style="background:darkturquoise;color:black">
<td><code>DarkTurquoise</code></td>
<td><code>00&nbsp;CE&nbsp;D1</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;206&nbsp;209</code>
</td></tr>
<tr style="background:lightseagreen;color:black">
<td><code>LightSeaGreen</code></td>
<td><code>20&nbsp;B2&nbsp;AA</code></td>
<td><code>&nbsp;32&nbsp;178&nbsp;170</code>
</td></tr>
<tr style="background:cadetblue;color:black">
<td><code>CadetBlue</code></td>
<td><code>5F&nbsp;9E&nbsp;A0</code></td>
<td><code>&nbsp;95&nbsp;158&nbsp;160</code>
</td></tr>
<tr style="background:darkcyan;color:black">
<td><code>DarkCyan</code></td>
<td><code>00&nbsp;8B&nbsp;8B</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;139&nbsp;139</code>
</td></tr>
<tr style="background:teal;color:black">
<td><code>Teal</code></td>
<td><code>00&nbsp;80&nbsp;80</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;128&nbsp;128</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Blues'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:lightsteelblue;color:black">
<td><code>LightSteelBlue</code></td>
<td><code>B0&nbsp;C4&nbsp;DE</code></td>
<td><code>176&nbsp;196&nbsp;222</code>
</td></tr>
<tr style="background:powderblue;color:black">
<td><code>PowderBlue</code></td>
<td><code>B0&nbsp;E0&nbsp;E6</code></td>
<td><code>176&nbsp;224&nbsp;230</code>
</td></tr>
<tr style="background:lightblue;color:black">
<td><code>LightBlue</code></td>
<td><code>AD&nbsp;D8&nbsp;E6</code></td>
<td><code>173&nbsp;216&nbsp;230</code>
</td></tr>
<tr style="background:skyblue;color:black">
<td><code>SkyBlue</code></td>
<td><code>87&nbsp;CE&nbsp;EB</code></td>
<td><code>135&nbsp;206&nbsp;235</code>
</td></tr>
<tr style="background:lightskyblue;color:black">
<td><code>LightSkyBlue</code></td>
<td><code>87&nbsp;CE&nbsp;FA</code></td>
<td><code>135&nbsp;206&nbsp;250</code>
</td></tr>
<tr style="background:deepskyblue;color:black">
<td><code>DeepSkyBlue</code></td>
<td><code>00&nbsp;BF&nbsp;FF</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;191&nbsp;255</code>
</td></tr>
<tr style="background:dodgerblue;color:black">
<td><code>DodgerBlue</code></td>
<td><code>1E&nbsp;90&nbsp;FF</code></td>
<td><code>&nbsp;30&nbsp;144&nbsp;255</code>
</td></tr>
<tr style="background:cornflowerblue;color:black">
<td><code>CornflowerBlue</code></td>
<td><code>64&nbsp;95&nbsp;ED</code></td>
<td><code>100&nbsp;149&nbsp;237</code>
</td></tr>
<tr style="background:steelblue;color:black">
<td><code>SteelBlue</code></td>
<td><code>46&nbsp;82&nbsp;B4</code></td>
<td><code>&nbsp;70&nbsp;130&nbsp;180</code>
</td></tr>
<tr style="background:royalblue;color:black">
<td><code>RoyalBlue</code></td>
<td><code>41&nbsp;69&nbsp;E1</code></td>
<td><code>&nbsp;65&nbsp;105&nbsp;225</code>
</td></tr>
<tr style="background:blue;color:black">
<td><code>Blue</code></td>
<td><code>00&nbsp;00&nbsp;FF</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0&nbsp;255</code>
</td></tr>
<tr style="background:mediumblue;color:black">
<td><code>MediumBlue</code></td>
<td><code>00&nbsp;00&nbsp;CD</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0&nbsp;205</code>
</td></tr>
<tr style="background:darkblue;color:black">
<td><code>DarkBlue</code></td>
<td><code>00&nbsp;00&nbsp;8B</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0&nbsp;139</code>
</td></tr>
<tr style="background:navy;color:black">
<td><code>Navy</code></td>
<td><code>00&nbsp;00&nbsp;80</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0&nbsp;128</code>
</td></tr>
<tr style="background:midnightblue;color:black">
<td><code>MidnightBlue</code></td>
<td><code>19&nbsp;19&nbsp;70</code></td>
<td><code>&nbsp;25&nbsp;&nbsp;25&nbsp;112</code>
</td></tr>

</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Purple, violet & magentas'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:lavender;color:black">
<td><code>Lavender</code></td>
<td><code>E6&nbsp;E6&nbsp;FA</code></td>
<td><code>230&nbsp;230&nbsp;250</code>
</td></tr>
<tr style="background:thistle;color:black">
<td><code>Thistle</code></td>
<td><code>D8&nbsp;BF&nbsp;D8</code></td>
<td><code>216&nbsp;191&nbsp;216</code>
</td></tr>
<tr style="background:plum;color:black">
<td><code>Plum</code></td>
<td><code>DD&nbsp;A0&nbsp;DD</code></td>
<td><code>221&nbsp;160&nbsp;221</code>
</td></tr>
<tr style="background:violet;color:black">
<td><code>Violet</code></td>
<td><code>EE&nbsp;82&nbsp;EE</code></td>
<td><code>238&nbsp;130&nbsp;238</code>
</td></tr>
<tr style="background:orchid;color:black">
<td><code>Orchid</code></td>
<td><code>DA&nbsp;70&nbsp;D6</code></td>
<td><code>218&nbsp;112&nbsp;214</code>
</td></tr>
<tr style="background:fuchsia;color:black">
<td><code>Fuchsia</code></td>
<td><code>FF&nbsp;00&nbsp;FF</code></td>
<td><code>255&nbsp;&nbsp;&nbsp;0&nbsp;255</code>
</td></tr>
<tr style="background:Magenta;color:black">
<td><code>Magenta</code></td>
<td><code>FF&nbsp;00&nbsp;FF</code></td>
<td><code>255&nbsp;&nbsp;&nbsp;0&nbsp;255</code>
</td></tr>
<tr style="background:mediumorchid;color:black">
<td><code>MediumOrchid</code></td>
<td><code>BA&nbsp;55&nbsp;D3</code></td>
<td><code>186&nbsp;&nbsp;85&nbsp;211</code>
</td></tr>
<tr style="background:mediumpurple;color:black">
<td><code>MediumPurple</code></td>
<td><code>93&nbsp;70&nbsp;DB</code></td>
<td><code>147&nbsp;112&nbsp;219</code>
</td></tr>
<tr style="background:blueviolet;color:black">
<td><code>BlueViolet</code></td>
<td><code>8A&nbsp;2B&nbsp;E2</code></td>
<td><code>138&nbsp;&nbsp;43&nbsp;226</code>
</td></tr>
<tr style="background:darkviolet;color:black">
<td><code>DarkViolet</code></td>
<td><code>94&nbsp;00&nbsp;D3</code></td>
<td><code>148&nbsp;&nbsp;&nbsp;0&nbsp;211</code>
</td></tr>
<tr style="background:darkorchid;color:black">
<td><code>DarkOrchid</code></td>
<td><code>99&nbsp;32&nbsp;CC</code></td>
<td><code>153&nbsp;&nbsp;50&nbsp;204</code>
</td></tr>
<tr style="background:darkmagenta;color:black">
<td><code>DarkMagenta</code></td>
<td><code>8B&nbsp;00&nbsp;8B</code></td>
<td><code>139&nbsp;&nbsp;&nbsp;0&nbsp;139</code>
</td></tr>
<tr style="background:purple;color:black">
<td><code>Purple</code></td>
<td><code>80&nbsp;00&nbsp;80</code></td>
<td><code>128&nbsp;&nbsp;&nbsp;0&nbsp;128</code>
</td></tr>
<tr style="background:indigo;color:black">
<td><code>Indigo</code></td>
<td><code>4B&nbsp;00&nbsp;82</code></td>
<td><code>&nbsp;75&nbsp;&nbsp;&nbsp;0&nbsp;130</code>
</td></tr>
<tr style="background:darkslateblue;color:black">
<td><code>DarkSlateBlue</code></td>
<td><code>48&nbsp;3D&nbsp;8B</code></td>
<td><code>&nbsp;72&nbsp;&nbsp;61&nbsp;139</code>
</td></tr>
<tr style="background:slateblue;color:black">
<td><code>SlateBlue</code></td>
<td><code>6A&nbsp;5A&nbsp;CD</code></td>
<td><code>106&nbsp;&nbsp;90&nbsp;205</code>
</td></tr>
<tr style="background:mediumslateblue;color:black">
<td><code style="margin-right:2em;">MediumSlateBlue</code>&nbsp;</td>
<td><code>7B&nbsp;68&nbsp;EE</code></td>
<td><code>123&nbsp;104&nbsp;238</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Whites'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:white;color:black">
<td><code>White</code></td>
<td><code>FF&nbsp;FF&nbsp;FF</code></td>
<td><code>255&nbsp;255&nbsp;255</code>
</td></tr>
<tr style="background:snow;color:black">
<td><code>Snow</code></td>
<td><code>FF&nbsp;FA&nbsp;FA</code></td>
<td><code>255&nbsp;250&nbsp;250</code>
</td></tr>
<tr style="background:honeydew;color:black">
<td><code>Honeydew</code></td>
<td><code>F0&nbsp;FF&nbsp;F0</code></td>
<td><code>240&nbsp;255&nbsp;240</code>
</td></tr>
<tr style="background:mintcream;color:black">
<td><code>MintCream</code></td>
<td><code>F5&nbsp;FF&nbsp;FA</code></td>
<td><code>245&nbsp;255&nbsp;250</code>
</td></tr>
<tr style="background:azure;color:black">
<td><code>Azure</code></td>
<td><code>F0&nbsp;FF&nbsp;FF</code></td>
<td><code>240&nbsp;255&nbsp;255</code>
</td></tr>
<tr style="background:aliceblue;color:black">
<td><code>AliceBlue</code></td>
<td><code>F0&nbsp;F8&nbsp;FF</code></td>
<td><code>240&nbsp;248&nbsp;255</code>
</td></tr>
<tr style="background:ghostwhite;color:black">
<td><code>GhostWhite</code></td>
<td><code>F8&nbsp;F8&nbsp;FF</code></td>
<td><code>248&nbsp;248&nbsp;255</code>
</td></tr>
<tr style="background:whitesmoke;color:black">
<td><code>WhiteSmoke</code></td>
<td><code>F5&nbsp;F5&nbsp;F5</code></td>
<td><code>245&nbsp;245&nbsp;245</code>
</td></tr>
<tr style="background:seashell;color:black">
<td><code>Seashell</code></td>
<td><code>FF&nbsp;F5&nbsp;EE</code></td>
<td><code>255&nbsp;245&nbsp;238</code>
</td></tr>
<tr style="background:beige;color:black">
<td><code>Beige</code></td>
<td><code>F5&nbsp;F5&nbsp;DC</code></td>
<td><code>245&nbsp;245&nbsp;220</code>
</td></tr>
<tr style="background:oldlace;color:black">
<td><code>OldLace</code></td>
<td><code>FD&nbsp;F5&nbsp;E6</code></td>
<td><code>253&nbsp;245&nbsp;230</code>
</td></tr>
<tr style="background:floralwhite;color:black">
<td><code>FloralWhite</code></td>
<td><code>FF&nbsp;FA&nbsp;F0</code></td>
<td><code>255&nbsp;250&nbsp;240</code>
</td></tr>
<tr style="background:ivory;color:black">
<td><code>Ivory</code></td>
<td><code>FF&nbsp;FF&nbsp;F0</code></td>
<td><code>255&nbsp;255&nbsp;240</code>
</td></tr>
<tr style="background:antiquewhite;color:black">
<td><code>AntiqueWhite</code></td>
<td><code>FA&nbsp;EB&nbsp;D7</code></td>
<td><code>250&nbsp;235&nbsp;215</code>
</td></tr>
<tr style="background:linen;color:black">
<td><code>Linen</code></td>
<td><code>FA&nbsp;F0&nbsp;E6</code></td>
<td><code>250&nbsp;240&nbsp;230</code>
</td></tr>
<tr style="background:lavenderblush;color:black">
<td><code>LavenderBlush</code></td>
<td><code>FF&nbsp;F0&nbsp;F5</code></td>
<td><code>255&nbsp;240&nbsp;245</code>
</td></tr>
<tr style="background:mistyrose;color:black">
<td><code>MistyRose</code></td>
<td><code>FF&nbsp;E4&nbsp;E1</code></td>
<td><code>255&nbsp;228&nbsp;225</code>
</td></tr>
</table>
<br>

END_NOTE

    end

    entry do
      name '**X11** Gray & blacks'
      notes <<END_NOTE

<table class="colors">
<tr>
<th style="background:lightgrey" rowspan="2"><a href="/wiki/HTML" title="">HTML</a> name
</th>
<tr>
<th style="background:lightgrey"><a href="/wiki/Hexadecimal" title="Hexadecimal"><code>Hex</code></a>
</th>
<th style="background:lightgrey"><code>Decimal</code>
</th></tr>

<tr style="background:gainsboro;color:black">
<td><code>Gainsboro</code></td>
<td><code>DC&nbsp;DC&nbsp;DC</code></td>
<td><code>220&nbsp;220&nbsp;220</code>
</td></tr>
<tr style="background:lightgray; color:black;">
<td><code>LightGray</code></td>
<td><code>D3&nbsp;D3&nbsp;D3</code></td>
<td><code>211&nbsp;211&nbsp;211</code>
</td></tr>
<tr style="background:silver;color:black">
<td><code>Silver</code></td>
<td><code>C0&nbsp;C0&nbsp;C0</code></td>
<td><code>192&nbsp;192&nbsp;192</code>
</td></tr>
<tr style="background:darkgray; color:black;">
<td><code>DarkGray</code></td>
<td><code>A9&nbsp;A9&nbsp;A9</code></td>
<td><code>169&nbsp;169&nbsp;169</code>
</td></tr>
<tr style="background:gray;color:black">
<td><code>Gray</code></td>
<td><code>80&nbsp;80&nbsp;80</code></td>
<td><code>128&nbsp;128&nbsp;128</code>
</td></tr>
<tr style="background:dimgray; color:white;">
<td><code>DimGray</code></td>
<td><code>69&nbsp;69&nbsp;69</code></td>
<td><code>105&nbsp;105&nbsp;105</code>
</td></tr>
<tr style="background:lightslategray; color:white;">
<td><code>LightSlateGray</code></td>
<td><code>77&nbsp;88&nbsp;99</code></td>
<td><code>119&nbsp;136&nbsp;153</code>
</td></tr>
<tr style="background:slategray; color:white;">
<td><code>SlateGray</code></td>
<td><code>70&nbsp;80&nbsp;90</code></td>
<td><code>112&nbsp;128&nbsp;144</code>
</td></tr>
<tr style="background:darkslategray; color:white;">
<td><code>DarkSlateGray</code></td>
<td><code>2F&nbsp;4F&nbsp;4F</code></td>
<td><code>&nbsp;47&nbsp;&nbsp;79&nbsp;&nbsp;79</code>
</td></tr>
<tr style="background:black;color:black">
<td><code>Black</code></td>
<td><code>00&nbsp;00&nbsp;00</code></td>
<td><code>&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;0</code>
</td></tr>

</table>


END_NOTE
  end
end

  notes <<END_NOTE

### Rationale

### History

END_NOTE

end
