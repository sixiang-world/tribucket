class Node < Formula
  desc "JavaScript runtime built on Chrome's V8 engine"
  homepage "https://nodejs.org/"
  version "22.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://nodejs.org/dist/v22.15.0/node-v22.15.0-darwin-arm64.tar.gz"
      sha256 "92eb58f54d172ed9dee320b8450f1390db629d4262c936d5c074b25a110fed02"
    end
    on_intel do
      url "https://nodejs.org/dist/v22.15.0/node-v22.15.0-darwin-x64.tar.gz"
      sha256 "f7f42bee60d602783d3a842f0a02a2ecd9cb9d7f6f3088686c79295b0222facf"
    end
  end

  on_linux do
    on_arm do
      url "https://nodejs.org/dist/v22.15.0/node-v22.15.0-linux-arm64.tar.gz"
      sha256 "c3582722db988ed1eaefd590b877b86aaace65f68746726c1f8c79d26e5cc7de"
    end
    on_intel do
      url "https://nodejs.org/dist/v22.15.0/node-v22.15.0-linux-x64.tar.gz"
      sha256 "29d1c60c5b64ccdb0bc4e5495135e68e08a872e0ae91f45d9ec34fc135a17981"
    end
  end

  def install
    bin.install Dir["node*"].first => "node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/node --version 2>&1", 1)
  end
end
