class CorrettoJdk17 < Formula
  desc "Amazon Corretto JDK 17 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "17.0.19.10.1"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-macos-jdk.tar.gz"
      sha256 "85667cd211b7cef065a35d1ffbe16a19059493ac0130be5f0f93465458525d77"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-macos-jdk.tar.gz"
      sha256 "f13aa9654979894dddcd448f8b95b9b355c299c137cb47367cbb01b668b65f7b"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.tar.gz"
      sha256 "495a5365af108172503c75d68476d5e8e4b0ff049908afc64feecb54b170de4c"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz"
      sha256 "b33adc502fdccdaa315feeafc5297b43e0009d0373182448920a46afe1656f34"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
