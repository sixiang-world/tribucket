class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.74.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.1/fzf-0.74.1-darwin_arm64.tar.gz"
      sha256 "849d1d33b050f04dd6b765665e417da151b0e4654dbed8f55c60fd8e23f3ba20"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.1/fzf-0.74.1-darwin_amd64.tar.gz"
      sha256 "642f29fb2800690385efb176a209b14d9f593795f0f70ee12c919ee15472e439"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.1/fzf-0.74.1-linux_arm64.tar.gz"
      sha256 "f22204dd1a091d43e102268d062fd53b47133c8d8581671ee5eb225b75e31183"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.1/fzf-0.74.1-linux_amd64.tar.gz"
      sha256 "df53438be5f51e151bb4044d78fda72bdfe209e3ecd2baecae48e8dea370c81b"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
