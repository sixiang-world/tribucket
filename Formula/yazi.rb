class Yazi < Formula
  desc "Blazing fast terminal file manager"
  homepage "https://github.com/sxyazi/yazi"
  version "26.8.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sxyazi/yazi/releases/download/v26.8.15/yazi-aarch64-apple-darwin.zip"
      sha256 "3f54907ea08abe96506f4b22239340ed8923a6aeaeae78f33d59bce57daca4cd"
    end
    on_intel do
      url "https://github.com/sxyazi/yazi/releases/download/v26.8.15/yazi-x86_64-apple-darwin.zip"
      sha256 "70bb2bcf57d8af862a54e2d12f2fddceefb9aa4ba3783e9a4dcbf2a8e64aacb3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sxyazi/yazi/releases/download/v26.8.15/yazi-aarch64-unknown-linux-gnu.zip"
      sha256 "f5a85771f06bb0e8c488136ae0aedaec8d341a7cee995549df391d7d852fe8d1"
    end
    on_intel do
      url "https://github.com/sxyazi/yazi/releases/download/v26.8.15/yazi-x86_64-unknown-linux-gnu.zip"
      sha256 "cc67eb7991550c2f9407cda52d3f5af0937627aa6884e7de99a04fcf059807e0"
    end
  end

  def install
    bin.install Dir["yazi*"].first => "yazi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yazi --version 2>&1", 1)
  end
end
