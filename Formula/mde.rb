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
  version "1.0.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.4-macos-arm64.tar.gz"
      sha256 "7fa2bd82cb68998bc3413ea0bb45c77cc4caf52609a4cf2e2845cfc45a17f837"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.4-macos-amd64.tar.gz"
      sha256 "db10fd2a6fea3581135c93a56c2dc5090326b50752787186fe59c532d82b4c46"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.4-linux-arm64.tar.gz"
      sha256 "95f2b796fe206ff884fa1420b2da5bead5c6dc90a3a055d15c714828ae5c8bbd"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.4-linux-amd64.tar.gz"
      sha256 "625b9657c214d68b104ee7f3542cde2b65597a80c7c6c9b9fa0681a9be30642f"
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
