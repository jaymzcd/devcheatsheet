cheatsheet do
  title 'Dev Cheat Sheet'
  docset_file_name 'dev'
  keyword 'dev'

  introduction <<END_INTRO
  A cheat sheet of useful things I do for development and commands, shortcuts
  and so on to make use of over time.

  I have remapped some of the default keybindings that I use a lot which is
  partly why I̕ʾve created this. Any command starting with a `;` is typically
  a [KeyboardMaestro](https://keyboardmaestro.com/) macro via a
  [_typed string trigger_](https://wiki.keyboardmaestro.com/trigger/Typed_String).
END_INTRO

  category do
    id 'Sublime Shortcuts'

    entry do
      command 'CTRL + -'
      name 'Jump back to last cursor location'
    end

    entry do
      command 'CMD + SHIFT + R'
      name 'Jump to a symbol across the project'
    end

    entry do
      command 'ALT + F'
      name '**Jedi**: Find uses'
    end

    entry do
      command 'ALT + D'
      name '**Jedi**: Show docstring'
    end

    entry do
      command 'ALT + G'
      name '**Jedi**: Goto definition'
    end

    entry do
      command 'ALT + A'
      name '**SublimeLinter**: Show errors'
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
      will reload modules once it's been loaded.
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

      To deal with temporary changes I don't want to accidentally commit:

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
      name 'Last branch matching'
      notes <<END_NOTE

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
      ```
END_NOTE
    end

    entry do
      command 'listnewcommitsbetweenbranches'
      name 'Commits across branches'
      notes <<END_NOTE

END_NOTE
    end

    entry do
      command 'bm'
      name 'Find branch with last commit date'
      notes <<END_NOTE

      This finds branches matching a given input along with the last commit date.

      ```sh
        function bm {
            gb -a --sort=committerdate --format='%(refname:short): %(committerdate:iso8601)' | \
            grep -i $1 | \
            sed 's/origin\///' | \
            sort | \
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

  end

  notes <<END_NOTE

END_NOTE

end
