class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.110"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.110/CLIProxyAPI_7.2.110_darwin_aarch64.tar.gz"
      sha256 "e6dac60c5740677c2bd8147666c290d79686d1a5b93264590897fffd036d1bba"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.110/CLIProxyAPI_7.2.110_darwin_amd64.tar.gz"
      sha256 "1d2a30512f9b9f458af95509cc3343afc08ccf1aa02dcb8b25760c02ef872aa3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.110/CLIProxyAPI_7.2.110_linux_aarch64.tar.gz"
      sha256 "587e0ae7f2dd5cabd41d1be68ddebc812f6b49d18e4127ca2d68486af351e2f0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.110/CLIProxyAPI_7.2.110_linux_amd64.tar.gz"
      sha256 "65504386611af722c2b103a6f7fbb38efd2d1822658008a03797e76e4f6bf738"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
