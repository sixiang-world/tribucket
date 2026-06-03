class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.52"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-macos-arm64"
      sha256 "915c17e414eac0f816ce6aa0f90536a3673ed52ffb2f1775d037237f3a9d87b5"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-macos-x64"
      sha256 "17fe1fe298db069928456c55c5caf4e236dec743375c8cb8ff9f72d61f867104"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-linux-arm64"
      sha256 "98930829de35b68251dd2e0e81cd352fc54e454486282a0f06d715204e905f64"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.52/codewhale-linux-x64"
      sha256 "13aeb0ef0d63288a09971363607660d22c512533111485e84c5a8a8f68e57a7e"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
