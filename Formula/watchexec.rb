class Watchexec < Formula
  desc "Execute commands in response to file modifications"
  homepage "https://github.com/watchexec/watchexec"
  version "2.8.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.8.0/watchexec-2.8.0-aarch64-apple-darwin.tar.xz"
      sha256 "8da8bdbfb8568138616a082c05a87224e08d5cb2994feb956426291cf0c6fe10"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.8.0/watchexec-2.8.0-x86_64-apple-darwin.tar.xz"
      sha256 "b7f694ad19c1cf168388f3295a5e825425f7dac5cd27cffd2d89a51ed4ab0f22"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.8.0/watchexec-2.8.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aaa5eb7e62e9ce99cad7f14260265aaa9df8884e195c0661ab011825a6d61634"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.8.0/watchexec-2.8.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21839e9840ef592b4d571885ccbd692f54ae5bd4231f3caf29fcf31fa7723afe"
    end
  end

  def install
    bin.install Dir["watchexec*"].first => "watchexec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchexec --version 2>&1", 1)
  end
end
