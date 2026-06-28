class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.2/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "69cdfe0fbf3f3a3efba9f54b9a89f740b24344b4cfa3efb6857a4e76ace8cf6a"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.2/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "a95b67c75466a87533931f705f68e4c0607149f6af7d2f30a59037875324fea0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.2/bottom_aarch64-linux-android.tar.gz"
      sha256 "0a501b3bbd7bae82e508552e39608e172fa345fc423be29da6322fb9c687199b"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.2/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48e6e40aabbeb31cdd34333208d16102aa190125dfed70b28d89ed20f43803ae"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
