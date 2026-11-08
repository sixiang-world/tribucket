class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.60"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.60/CLIProxyAPI_8.0.60_darwin_aarch64.tar.gz"
      sha256 "9be68e64fc614a5474b98d310bb9057d6bdecb619cedec01febbb4073fdb19df"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.60/CLIProxyAPI_8.0.60_darwin_amd64.tar.gz"
      sha256 "8892224d75f3d29a33efd0e4b8a00bb97505266cf2b9bc80d1adb3a787d89910"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.60/CLIProxyAPI_8.0.60_linux_aarch64.tar.gz"
      sha256 "1c45a42770b5307a52599a2668645face8fb95c0f2dc6ee610e0992592c643d8"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.60/CLIProxyAPI_8.0.60_linux_amd64.tar.gz"
      sha256 "34720cd10deef235481e80625e0c02dee934eefdd03dc8bc4f327156fa766211"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
