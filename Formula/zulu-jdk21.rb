class ZuluJdk21 < Formula
  desc "Azul Zulu - certified build of OpenJDK"
  homepage "https://www.azul.com/products/zulu-community/"
  version "21.0.13.0.3"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.109-ca-jdk21.0.13.0.3-macosx_aarch64.tar.gz"
      sha256 "3fb0c7b00d48e833ad7a1ab1001c9d44cd130be20c198a4744f318592d83af40"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.109-ca-jdk21.0.13.0.3-macosx_x64.tar.gz"
      sha256 "c7364c19e1d941b71951b754481851cfad31f7d99e0e3a0636d79f1c63a3559b"
    end
  end

  on_linux do
    on_arm do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.109-ca-jdk21.0.13.0.3-linux_aarch64.tar.gz"
      sha256 "eb6b89b23b9eb5661b29a4e8c09e8e91952cbdfa87045d36e9078e37388c2dc3"
    end
    on_intel do
      url "https://cdn.azul.com/zulu/bin/zulu21.54.109-ca-jdk21.0.13.0.3-linux_x64.tar.gz"
      sha256 "abe544103f1c4f0cc4b8997c0cac847eb1e842382eef57ce361c982fb0a3de11"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
