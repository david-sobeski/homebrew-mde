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
  version "1.0.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.6-macos-arm64.tar.gz"
      sha256 "cd86f937442817c9ce3e270c591226c730a17bf5f695d8ac9838d043a8a542c6"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.6-macos-amd64.tar.gz"
      sha256 "f77e1def7543dbefeb7d805fc923b2f01f18e50872e249412b7c11b9ec210142"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.6-linux-arm64.tar.gz"
      sha256 "f3e50984d3fde23fff278fbc749025f1152de8e1ad8413f0d8dc8ff8ead6f047"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.6-linux-amd64.tar.gz"
      sha256 "b7edcdc0285cf0a641624ced45737ee50ef3d9d985dd84500abcc90b3772d978"
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
