class Erdtree < Formula
  desc "Modern filesystem and disk usage visualizer"
  homepage "https://github.com/solidiquis/erdtree"
  version "3.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/solidiquis/erdtree/releases/download/v3.1.2/erd-v3.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "58cda585024b437550eafec1a5c7fbdbc917153e3b2f09571637f941a48d265f"
    end
    on_intel do
      url "https://github.com/solidiquis/erdtree/releases/download/v3.1.2/erd-v3.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "ba817e64b09e2f2505c8ce71df941aa5d73046d5bebdff83b656541cdbead688"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/solidiquis/erdtree/releases/download/v3.1.2/erd-v3.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c3e5cc90bb513dcaff4956c820827e84e28e7a9e354827c36726d5289624f99b"
    end
    on_intel do
      url "https://github.com/solidiquis/erdtree/releases/download/v3.1.2/erd-v3.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9354667bc1ef744cb363604d4eb5b6784205b7fb1c283f4c0f9d78e3ad07e42f"
    end
  end

  def install
    bin.install Dir["erd*"].first => "erd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erd --version 2>&1", 1)
  end
end
