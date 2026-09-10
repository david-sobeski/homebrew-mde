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
  version "1.0.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.7-macos-arm64.tar.gz"
      sha256 "16da0f3e78d509e4d7849e11b658c167339f192a83fed9d3a1d6a10a429bdb0c"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.7-macos-amd64.tar.gz"
      sha256 "7ab0b8fb1094b37bfbc6012fc71696642ae8d42b0468618c71037215b11203ca"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.7-linux-arm64.tar.gz"
      sha256 "058a06787b06e5f8c2695169cf4703def0973f100ad6279dc2507ed8e1fea9e1"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.7-linux-amd64.tar.gz"
      sha256 "706ad9344421f900e89ade5dc87c2486739531c88518e40fe88a9185198b2f00"
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
