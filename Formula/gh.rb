class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.103.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_macOS_arm64.zip"
      sha256 "d700207eae9ae98fe2b89535c2c087c07823d4628c56364695a5a07ef311c062"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_macOS_amd64.zip"
      sha256 "a2f86418f4350ae6e9ec60d5000bdf7665728436946a97fc27fe50e6ae752682"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_linux_arm64.tar.gz"
      sha256 "ee32df2323c8847f5fac6cb6b4b69ca75828e9329a8f22f677021f7b3306ce63"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_linux_amd64.tar.gz"
      sha256 "4c806978ffce1cec70853302a56d70ac6da4f19bae7adca4e1a8ab00633dd91d"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
