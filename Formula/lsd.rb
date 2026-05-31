class Lsd < Formula
  desc "The next gen ls command (LSDeluxe)"
  homepage "https://github.com/lsd-rs/lsd"
  version "1.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/lsd-rs/lsd/releases/download/v1.2.0/lsd-v1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "9e34a5d392ff913302098aad0543dafa1883c531eaf229b82f086c3fca675e3e"
    end
    on_intel do
      url "https://github.com/lsd-rs/lsd/releases/download/v1.2.0/lsd-v1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "00d3c50551b270bbdf7da97816e5ba7f5fd10294cd310165f7f8b5523e738b9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lsd-rs/lsd/releases/download/v1.2.0/lsd-v1.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48c069cf73a8ed0851f366afeac86e3a9b7db416133f45d033d31d123f819f26"
    end
    on_intel do
      url "https://github.com/lsd-rs/lsd/releases/download/v1.2.0/lsd-v1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "57d3b5859254adcfb8374ce98159cca97a14959997d2ae1176d2cff59556d829"
    end
  end

  def install
    bin.install Dir["lsd*"].first => "lsd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsd --version 2>&1", 1)
  end
end
