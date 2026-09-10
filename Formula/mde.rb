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
  version "1.0.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.5-macos-arm64.tar.gz"
      sha256 "4cd677127b9413f8c48a864c772da0b48f30ab416b3f3db88b3538c9313633eb"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.5-macos-amd64.tar.gz"
      sha256 "0bac8f78f44725203b622b9205e6990a5c3c1e775a62e9ae3f6e5784b5f0ca8c"
    end
  end

  on_linux do
    on_arm do
      url "https://flushodds.com/downloads/mde-1.0.5-linux-arm64.tar.gz"
      sha256 "c6974fdc6dc0b6614e318ed5e6046ecfe0bf8eecc4a7f23d8d7fdef401390993"
    end
    on_intel do
      url "https://flushodds.com/downloads/mde-1.0.5-linux-amd64.tar.gz"
      sha256 "8f68bea9b7a35bc8c39c9ea7e8f49bb45687d294cffa847cfff3f71de014ec90"
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
