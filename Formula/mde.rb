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
  version "1.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.1-macos-arm64.tar.gz"
      sha256 "9718d6f1d0d5ea64a34b0573882b7765e309b33293e1e79000fb4ad28eb8fb32"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.1-macos-amd64.tar.gz"
      sha256 "1eafbd42a7c5612c612e540e8c2b32299fc28cbf5d73e760f535b98288898cba"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.1-linux-arm64.tar.gz"
      sha256 "97151ba6b7fc52d2aa8b3c8708bab30fbfa7f61b2a33a178e911c2c04e2e62f5"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.1-linux-amd64.tar.gz"
      sha256 "400187d4705d9715332a2717a387f81065a2c84d629e85f38e4144bbc20f9903"
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
