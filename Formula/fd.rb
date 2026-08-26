class Fd < Formula
  desc "A simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  version "10.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.0/fd-v10.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "b67e1836c468e42e411984b56e52fa7abec08c2bd22c867398e7cc134aac5e12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.0/fd-v10.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0ee43802e3313a317c5af2f4eabd6ba13eeedd595af9775f05e18a13ac4f52c"
    end
    on_intel do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.0/fd-v10.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a1259cd129636efbc3fef123525c1b49e88fe5088c012630983c310e52fdfa95"
    end
  end

  def install
    bin.install Dir["fd*"].first => "fd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fd --version 2>&1", 1)
  end
end
