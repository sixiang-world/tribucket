class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.2/tribucket-darwin-arm64"
      sha256 "8c202bd14529af782eb7d6edbfdebebb4388705119166dffaa5adb144e6c1f8b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.2/tribucket-linux-arm64"
      sha256 "a45a9ba3acad66f5cf20aebaac85b67dfcb309a002270805d356439c2ecea8b8"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.2/tribucket-linux-amd64"
      sha256 "e6ab6197b84191313f9c2f0c463fbd9ed3457cb2530c921c4b3637b6cedae4d3"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
