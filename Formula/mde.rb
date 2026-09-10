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
  version "1.0.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.3-macos-arm64.tar.gz"
      sha256 "447385c92739abd0fa987c2bdddb411b123def9120c84c46a24666fabd4084a2"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.3-macos-amd64.tar.gz"
      sha256 "3acc529dd90bcf2c80895215653ef7f05d9d71ad9cba75b36bf99918082a3385"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.3-linux-arm64.tar.gz"
      sha256 "04133f4c8a85bdcac820203948c8b813126ab0959f154a3d86e6771c162fa90c"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.3-linux-amd64.tar.gz"
      sha256 "22eeb1972e3692c5878edfdb10e5113c92f9dd21100a4fc9b643ca825706fcf6"
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
