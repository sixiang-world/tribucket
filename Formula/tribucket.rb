class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.2/tribucket-darwin-arm64"
      sha256 "2ddb356ddce5a47c2bc9469800f6eb8a758d6e49eb8e77ea1b7f2ea0fb95b3a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.2/tribucket-linux-arm64"
      sha256 "599c3ccd1257493d81ab7e63672487e087cd15caffdcaef1f8d2a2d10a7762db"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.2/tribucket-linux-amd64"
      sha256 "0aeb3f1cb26c4f5acd855e51bf3fee4735a55b9d5010310fce8e85dbdce7e0fe"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
