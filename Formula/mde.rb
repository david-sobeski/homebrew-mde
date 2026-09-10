# Homebrew formula for mde.
#
# It installs the prebuilt binary from the download site rather than
# compiling: mde is a single static executable with no dependencies, so there
# is nothing for a build to decide and nothing for the user to wait for. A tap
# gets no bottles from Homebrew's build farm, and without them a source formula
# would drag in the whole Go toolchain to produce a file that already exists.
#
# The archives are the same ones the download page offers, checksummed against
# the SHA256SUMS published beside them.
#
# Update it for a new release with:
#
#   packaging/homebrew/update-formula.sh v1.0.1
#
# See docs/homebrew.md for how the tap is published.
class Mde < Formula
  desc "Full-screen markdown editor for the terminal"
  homepage "https://flushodds.com/"
  # Stated rather than scanned. The file names carry two numbers, and Homebrew
  # picks the wrong one: it reads the 64 of arm64 as the version.
  version "1.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.2-macos-arm64.tar.gz"
      sha256 "15f4b33330692f338e09b9ac8420cc29de2c7de028dedf7719aa2137ba169bdf"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.2-macos-amd64.tar.gz"
      sha256 "f5c0862af201e8d4be32d8cb922475926872bef6222f97c2ac0fb1111531e6cd"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.2-linux-arm64.tar.gz"
      sha256 "f662b5a51e1b35d69a7e9e232489f7afe193c5565e1e131fe6bbb6d8675965d5"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.2-linux-amd64.tar.gz"
      sha256 "30f244835cb13ed6a9fbb7a0340dbb5e6aac95bfa296ac172e8147b514af3520"
    end
  end

  def install
    bin.install "mde"

    # The sample vault and document are worth keeping: they are what makes the
    # graph and the wikilink navigation demonstrable straight after install.
    pkgshare.install "samples"
  end

  def caveats
    <<~EOS
      Sample documents were installed to:
        #{pkgshare}/samples

      Try them with:
        mde #{pkgshare}/samples/sample.md
    EOS
  end

  test do
    assert_match "mde", shell_output("#{bin}/mde --version")

    (testpath/"note.md").write("# Title

A [[wikilink]] and some **bold** text.
")
    html = shell_output("#{bin}/mde --print #{testpath}/note.md")
    assert_match "<h1", html
    assert_match "<strong>bold</strong>", html
  end
end
