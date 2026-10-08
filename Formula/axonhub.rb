class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta11/axonhub_1.0.0-beta11_darwin_arm64.zip"
      sha256 "5cdd64be9b159da228c77524e0a347a34036bfc14c41c587143c7f22f8862f7e"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta11/axonhub_1.0.0-beta11_darwin_amd64.zip"
      sha256 "f7b2e14aba8bb11d6d58f1246c444da324141b3bee56deb7d7369c5dd66586ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta11/axonhub_1.0.0-beta11_linux_arm64.zip"
      sha256 "aa302891e14e557a3abe41cb6b3cc99126d4829699d1fe16c898e961aa682df8"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta11/axonhub_1.0.0-beta11_linux_amd64.zip"
      sha256 "f4bc60c868d794d476e5854eb6352ca1eaf284fd031c529feb60b14e4eaf81c4"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
