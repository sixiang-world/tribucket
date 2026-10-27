class CorrettoJdk8 < Formula
  desc "Amazon Corretto JDK 8 - no-cost, production-ready OpenJDK"
  homepage "https://aws.amazon.com/corretto/"
  version "8.492.09.2"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
      sha256 "30c7edb7134712148cc323d4ccfc816758e7f1e4bb8aa1287795872fa5eca610"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-macos-jdk.tar.gz"
      sha256 "adfbe1c7a47ee98fe70f8028087614c93c137a2a54d8b010313104ef0325b656"
    end
  end

  on_linux do
    on_arm do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-linux-jdk.tar.gz"
      sha256 "0115aad5747b262c7ae0e7f3ae1fc20933f3950843cfa365b49eca7be0c84a90"
    end
    on_intel do
      url "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz"
      sha256 "2f2df938886e61c80010ed5af0ea6504ca685280a3b807c5c59ed3ca4fb95be4"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
