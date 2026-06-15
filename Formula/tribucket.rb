class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.4.0/tribucket-darwin-arm64"
      sha256 "6385bdd2864dfeb192cfbd7693bb7c1eaae703d5585aa084cfeb0e89d58c4ddc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.4.0/tribucket-linux-arm64"
      sha256 "c4c211d7c35fda4485cd12a5df5483d2475631ae74552c3b039d8efb7fe6de99"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.4.0/tribucket-linux-amd64"
      sha256 "9baedd8c564adb269a3959230f249d808c5f10c56d6e77b4163d8909629dbe18"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
