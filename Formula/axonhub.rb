class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta9/axonhub_1.0.0-beta9_darwin_arm64.zip"
      sha256 "caa30348521f512d1b08f15a3c4239384460a15a2ff5714c1999693fa9b84b69"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta9/axonhub_1.0.0-beta9_darwin_amd64.zip"
      sha256 "eeea65c577e991ddacda40e9a5bbd2a8cd1d7add0f340644c2618192fbf14f44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta9/axonhub_1.0.0-beta9_linux_arm64.zip"
      sha256 "d21bc55992921f162473ddbfa54874737302606d7d538b7ec817e9d4ee749b68"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta9/axonhub_1.0.0-beta9_linux_amd64.zip"
      sha256 "fd1dcfcb70bf58551322852f7425a18a7f390baa67b806ae634b9158ab10ea00"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
