class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.59"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.59/codewhale-macos-arm64"
      sha256 "bf577561991207a04a91721be6c3f6ec52765b411072d69e8a8a5b6ee7a40122"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.59/codewhale-macos-x64"
      sha256 "ac48165591fd02faefe25788dd2026eb73a9bf8ef312a35384f9db5f3a46e171"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.59/codewhale-linux-arm64"
      sha256 "354ef85b184b7531fac9601d6c696f901fb4da0df69f81a3c0b82490356d6403"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.59/codewhale-linux-x64"
      sha256 "b62fc804f65525d68bbd0d3439ebf34df70c4345c710bbce29372e978fa2060f"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
