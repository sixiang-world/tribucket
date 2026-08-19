class MicrosoftJdk11 < Formula
  desc "Microsoft Build of OpenJDK 11"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-aarch64.tar.gz"
      sha256 "05161b4b839beafcb361a49c8bfda07f06923562d91c2271dbf511ae48d07314"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-x64.tar.gz"
      sha256 "96088abf8d4a483cfc1f7e1f68d5f9e01e396b5903571f087efb35867497d390"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-aarch64.tar.gz"
      sha256 "d2918bde1083ed719946c6272a6f45ef8d1ead6ba747ee312348a493ebbc19b7"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-x64.tar.gz"
      sha256 "f528626d8830c4475e23ac91017117c4fd439cc2cb51af1c32fc70ac74f33c04"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
