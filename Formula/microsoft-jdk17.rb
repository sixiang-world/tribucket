class MicrosoftJdk17 < Formula
  desc "Microsoft Build of OpenJDK 17"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "17"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-aarch64.tar.gz"
      sha256 "5ce59293b2eb30cb4e9f0c72c1ea27cea2bfaadcf0dbbe87ddd92e031c4210be"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-macos-x64.tar.gz"
      sha256 "6af364adc0c79a5a8d4ea2edc5ecb8cd7e47360c2944947c70482e18befea046"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-aarch64.tar.gz"
      sha256 "45248a01b7ea98ac568ae801274a98b3e581233bd12b0d54944598fcdde37b5f"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-17-linux-x64.tar.gz"
      sha256 "127694536ed818bb135d2464ea76fabe3cfc485c660a6304301775e26a0b7035"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
