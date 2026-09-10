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
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.0-macos-arm64.tar.gz"
      sha256 "6855d4807f4dd3dae4b5a16fb62df07e52d0d7a2c51d56feac3ded5dcc9f2afc"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.0-macos-amd64.tar.gz"
      sha256 "be2ef450eccfabce3ebaeaf23e568af75d10f4932a88276db22b085112895a7b"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.0-linux-arm64.tar.gz"
      sha256 "8a4c744f51781d083d9dfd2b83421e367efb3d2d0f83c2df421abe1d313a854e"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.0-linux-amd64.tar.gz"
      sha256 "12064d27f05094f5228287e6af81ac6b540395ebefff4f102d2bce1f6c6a5527"
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
