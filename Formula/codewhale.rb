class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.57"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.57/codewhale-macos-arm64"
      sha256 "8b8543de53fc6aae5f4cd1cd2edc0fd699da69b00b8de78241885eb253e65e5c"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.57/codewhale-macos-x64"
      sha256 "9dc63187cad998b2a59e5d495366df8487331c7fe8195d678adfec4944563373"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.57/codewhale-linux-arm64"
      sha256 "5454b1946f2d18aa3ab2b1a0bc15c488902a434febbe3fbf98ddb749d491b6d5"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.57/codewhale-linux-x64"
      sha256 "1e9d19ea6c1e682fac07f047d8aa43d56fec752d267baf6912b2a258e6b61aa6"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
