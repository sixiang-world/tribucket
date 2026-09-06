class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta10/axonhub_1.0.0-beta10_darwin_arm64.zip"
      sha256 "0ff6b51f9d41cf4ba84f16e3091a5a6f58e22ff4f69782ab2548c38d13498765"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta10/axonhub_1.0.0-beta10_darwin_amd64.zip"
      sha256 "b945f8a7ee5d828c27b9e8e0e61b5e446e1d1d67a7857e58a21c3f8bc97ff086"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta10/axonhub_1.0.0-beta10_linux_arm64.zip"
      sha256 "ab8c2a7501a0cbb7966e7b28a9671bf1010ea7834dcab7386a97e8fbc5992779"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta10/axonhub_1.0.0-beta10_linux_amd64.zip"
      sha256 "bc73017ced989a04f2913e3ff57333f5e4e2cba7cebcb0b9e1e272b9db96b46b"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
