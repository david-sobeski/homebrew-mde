# homebrew-mde

A Homebrew tap for [mde](https://github.com/david-sobeski/mde), a full-screen
markdown editor for the terminal.

```sh
brew install david-sobeski/mde/mde
```

Or tap it first, and then install by name:

```sh
brew tap david-sobeski/mde
brew install mde
```

The formula builds from the tagged source, which is pure Go with no
dependencies, so one formula serves Apple Silicon, Intel and Linux alike. Go is
a build dependency only and nothing is left behind once the binary is compiled.

Updating is `brew upgrade` like anything else.

The formula lives in the main repository as `packaging/homebrew/mde.rb` and is
copied here on release; see
[docs/homebrew.md](https://github.com/david-sobeski/mde/blob/main/docs/homebrew.md).

MIT licensed, the same as mde itself.
