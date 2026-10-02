class Watchexec < Formula
  desc "Execute commands in response to file modifications"
  homepage "https://github.com/watchexec/watchexec"
  version "2.7.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.4/watchexec-2.7.4-aarch64-apple-darwin.tar.xz"
      sha256 "1e5052fe1f0690cd04d13d59f2d6bb0b090985d88c7406acadacd1198f58706e"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.4/watchexec-2.7.4-x86_64-apple-darwin.tar.xz"
      sha256 "e3016a20879510ea3a585e75d73a5aff8be0648d9e88d71439d515e63da13255"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.4/watchexec-2.7.4-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b649cf89bda51ba060abb9e9765ea585823ee94b9bf2e2ad86081323a13a81c4"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.4/watchexec-2.7.4-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d7e89e8815ac1b4eafb9497ed0a8ada986117fbba460b2f9282e0e160f776dd"
    end
  end

  def install
    bin.install Dir["watchexec*"].first => "watchexec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchexec --version 2>&1", 1)
  end
end
