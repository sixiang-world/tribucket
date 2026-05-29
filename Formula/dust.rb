class Dust < Formula
  desc "More intuitive version of du (disk usage)"
  homepage "https://github.com/bootandy/dust"
  version "1.2.4"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.4/dust-v1.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "bf84d3ff7f58e325d3eb5bb7696df6b22ef1e01fec80c2d8f7c9d3e611be66f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bootandy/dust/releases/download/v1.2.4/dust-v1.2.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1903296e662a80a504b132525c9360b503de3b900970e1245268605fc65e366d"
    end
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.4/dust-v1.2.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "707cfdbfb9d2dc536f8c3853815bbe98a01012f2772463835edae06816551160"
    end
  end

  def install
    bin.install Dir["dust*"].first => "dust"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dust --version 2>&1", 1)
  end
end
