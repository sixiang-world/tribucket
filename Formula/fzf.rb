class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.74.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.3/fzf-0.74.3-darwin_arm64.tar.gz"
      sha256 "1f8501cea4f9c0c2d6110d0ff75d0ec9451cd9d7524d9a26244a154ea89f3bd5"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.3/fzf-0.74.3-darwin_amd64.tar.gz"
      sha256 "b8a231250eedec244539ade3dc437bcd60e545a099c6cc0c8a11bdbd8574b9bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.3/fzf-0.74.3-linux_arm64.tar.gz"
      sha256 "4a17a17b46bd0c4873e995533de508995c11572c0be0664a5dbcf13f60463046"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.3/fzf-0.74.3-linux_amd64.tar.gz"
      sha256 "3501a595e4b5c40a6b047340a0e8f805c46fd4e61ef95ef8a136ba8c61cf6f22"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
