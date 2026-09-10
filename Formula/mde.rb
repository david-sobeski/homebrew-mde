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
      sha256 "f4805852ddc0eb37b355f24e7fa99bc5fb1513e98398a230f89976dd234b3706"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.1-macos-amd64.tar.gz"
      sha256 "d7b953540de96b05c2a2df3f36f63008865e68458926f0efddcb1b47d57cb1a0"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.1-linux-arm64.tar.gz"
      sha256 "025caf843691970d4e641b486a54c7d24447c2c7bd813212f0c55bedecdb18e4"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.1-linux-amd64.tar.gz"
      sha256 "4b0176c220621b8bb5381aa011c7514f9b9ac0ffdd4fced1eb6a9ff015a495a1"
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
