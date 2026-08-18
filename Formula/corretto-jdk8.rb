class CorrettoJdk8 < Formula
  desc "Amazon Corretto JDK 8 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "8.492.09.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
      sha256 "425eaab72289ffb346fae3d904de7301dc9fcb70ae9dc095fac2ea1b1c621bea"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-macos-jdk.tar.gz"
      sha256 "6763f63fd4ffab020fefc54b96d29e02a82b8745a6e87aaccb9af92f3c33d5da"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-linux-jdk.tar.gz"
      sha256 "54d872a37ee35eafdf057ceb2dad2d25c250580db91e7a08f656c945d489a375"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz"
      sha256 "56f0f6ab9b50f69bdf72705542342c0ff9c4e0f531f03d6751dcebe164308983"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
