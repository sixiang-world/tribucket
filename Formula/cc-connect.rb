class CcConnect < Formula
  desc "Claude Code connectivity utility"
  homepage "https://github.com/chenhg5/cc-connect"
  version "1.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.0/cc-connect-v1.5.0-darwin-arm64.tar.gz"
      sha256 "458e7f1e783e87352fa402732d2b2da5072bbda286ec0fbd4dc01ed37b2084ce"
    end
    on_intel do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.0/cc-connect-v1.5.0-darwin-amd64.tar.gz"
      sha256 "30b403b0b64c934795281d598079dfeeea0daaaeb6b415d8602a13bd2dcb2092"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.0/cc-connect-v1.5.0-linux-arm64.tar.gz"
      sha256 "360916e64c81714b4b295905b7aa95a62d3b5bfba0fb306f29a4560224d07ca3"
    end
    on_intel do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.0/cc-connect-v1.5.0-linux-amd64.tar.gz"
      sha256 "72859035a1ee011b710204fc508de711838f919eb2ae6f104f1ddb3e5cd8ca87"
    end
  end

  def install
    bin.install Dir["cc-connect*"].first => "cc-connect"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-connect --version 2>&1", 1)
  end
end
