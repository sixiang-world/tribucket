class CorrettoJdk17 < Formula
  desc "Amazon Corretto JDK 17 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "17.0.19.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-macos-jdk.tar.gz"
      sha256 "3cd5a2bdd380a5654aa1ef5eda3032f60021e8e48a0bdd552e8e39b032705732"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-macos-jdk.tar.gz"
      sha256 "dca4175d94d404533c4230eff1a64cc3ae9f3919bfdf35902c64bfd4d3bcb70e"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.tar.gz"
      sha256 "33412bba53b912b21528150df7cf60c161d10fc3b7dae89cd5383d8f3c0362c0"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz"
      sha256 "8f9a2ddb131ec5317419f2b0769240fe22ce27f8a0ae43f5346d53e1c8aec6a0"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
