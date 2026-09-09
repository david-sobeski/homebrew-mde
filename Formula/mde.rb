# Homebrew formula for mde.
#
# It builds from the tagged source rather than shipping a binary, which is what
# Homebrew prefers and what lets one formula serve Apple Silicon, Intel and
# Linux from a single line. Go is a build dependency only: nothing is left
# behind once the binary is compiled.
#
# Update it for a new release with:
#
#   packaging/homebrew/update-formula.sh v1.0.1
#
# See docs/homebrew.md for how the tap is published.
class Mde < Formula
  desc "Full-screen markdown editor for the terminal"
  homepage "https://github.com/david-sobeski/mde"
  url "https://github.com/david-sobeski/mde/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7ed50c03d3214088f487eb4bbd08793c87202a0c51a1d9cdfec90956c8ff6e82"
  license "MIT"
  head "https://github.com/david-sobeski/mde.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))

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
    assert_match "mde #{version}", shell_output("#{bin}/mde --version")

    (testpath/"note.md").write("# Title\n\nA [[wikilink]] and some **bold** text.\n")
    html = shell_output("#{bin}/mde --print #{testpath}/note.md")
    assert_match "<h1", html
    assert_match "<strong>bold</strong>", html
  end
end
