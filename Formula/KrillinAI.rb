class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "1.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v1.4.0/KlicStudio_1.4.0_macOS_arm64"
      sha256 "e56b82421f8ef7ca43b1601e660f0c9c1175afaa5e96e649b02ee07c1f5e43c7"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v1.4.0/KlicStudio_1.4.0_macOS_amd64"
      sha256 "47eabb22ea9ce28e7942e17315a3683631d4c62f00f580b960afb3dd84212093"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v1.4.0/KlicStudio_1.4.0_Linux_arm64"
      sha256 "383a513dffc564a6f08f42dfce813acd364c1c7d2dafb0d099920e1e0be555d1"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v1.4.0/KlicStudio_1.4.0_Linux_x86_64"
      sha256 "915d5056a65cd214adb06f75ed06fb03abc059e66f6b56348cb95cb33b54dc82"
    end
  end

  def install
    bin.install Dir["KlicStudio*"].first => "KlicStudio"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KlicStudio --version 2>&1", 1)
  end
end
