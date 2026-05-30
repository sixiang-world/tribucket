class MicrosoftJdk11 < Formula
  desc "Microsoft Build of OpenJDK 11"
  homepage "https://learn.microsoft.com/java/openjdk/overview"
  version "11"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-aarch64.tar.gz"
      sha256 "03e7a317bf74e370252a86049d379183628dfb7320e9e74ae0bdcfd8a4506bd9"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-macos-x64.tar.gz"
      sha256 "f16583e0fe5ce4274dc4bec49593470d899353b16f5571a2cd980d6438f9f3ef"
    end
  end

  on_linux do
    on_arm do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-aarch64.tar.gz"
      sha256 "545c6ff26e02b494d323975f233bc1acb0e4e36483be86c901f29368d66aebca"
    end
    on_intel do
      url "https://aka.ms/download-jdk/microsoft-jdk-11-linux-x64.tar.gz"
      sha256 "d10004134ed177a4d1a5417e8216af4baf44b4abbaf44d8b973d32088cb03b59"
    end
  end

  def install
    bin.install Dir["java*"].first => "java"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/java --version 2>&1", 1)
  end
end
