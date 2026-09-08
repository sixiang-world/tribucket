class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.155"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.155/CLIProxyAPI_7.2.155_darwin_aarch64.tar.gz"
      sha256 "f90c503ce41a798c85b6f61dfe5fe8b812c1b889634f0c80d04ee376424fe305"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.155/CLIProxyAPI_7.2.155_darwin_amd64.tar.gz"
      sha256 "198794a2fafb9fb8083476ac18232647c57d443422aa3f008d19ed7e75ca4604"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.155/CLIProxyAPI_7.2.155_linux_aarch64.tar.gz"
      sha256 "bd5f6b705124e4af160b1d236e6739bbcd10b7c76d0c5dda96095ec19f38d5e7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.155/CLIProxyAPI_7.2.155_linux_amd64.tar.gz"
      sha256 "5eb8e1ab3f90aa22e4843d0c881f113d4e359a8cb3d3ec130a53e356060be730"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
