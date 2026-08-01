class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.74.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.2/fzf-0.74.2-darwin_arm64.tar.gz"
      sha256 "d60ddb36356566ac69bae7c3504e888916cf747c9ad2132141c09229b1e28dee"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.2/fzf-0.74.2-darwin_amd64.tar.gz"
      sha256 "b019ae8bcca33945a2ffbbbf8369705405cd1406fc4d74267e712797010e3676"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.2/fzf-0.74.2-linux_arm64.tar.gz"
      sha256 "1373e3f5ed3c468179d4529942ddd96c234bcad1bcacaf238916e26a5234b5b2"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.2/fzf-0.74.2-linux_amd64.tar.gz"
      sha256 "b3648f48675612b69ee35371cf6dc99ca96d767e89b912d079080916ac8ba8bd"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
