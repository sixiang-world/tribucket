class LibericaJdk8 < Formula
  desc "BellSoft Liberica JDK 8 - open-source Java implementation"
  homepage "https://bell-sw.com/java"
  version "8u492+9"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/8u492+9/bellsoft-jdk8u492+9-macos-aarch64.tar.gz"
      sha256 "6ef003fa49d8441412e5d315eda75680fc6df1c51809066f3dbd4cadacb55e13"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/8u492+9/bellsoft-jdk8u492+9-macos-amd64.tar.gz"
      sha256 "2f14159e23f2265721345d59e9dcae76c80265df979c1b1c1f1c79d3f2c9de8d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bell-sw/Liberica/releases/download/8u492+9/bellsoft-jdk8u492+9-linux-aarch64.tar.gz"
      sha256 "01e8729a96f1a4fa25e87688acd42b8146eeaad41e3b333c0f90f7411da00da7"
    end
    on_intel do
      url "https://github.com/bell-sw/Liberica/releases/download/8u492+9/bellsoft-jdk8u492+9-linux-amd64.tar.gz"
      sha256 "23d51bf106067425c94f9286d1ee7579a112a01ae8cf7fd69b3a920e088a7be5"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
