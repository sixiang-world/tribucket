class QqmailCli < Formula
  desc "Unofficial safety-first QQ Mail CLI for scripts and AI agents"
  homepage "https://github.com/sixiang-world/qqmail-cli"
  version "0.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_darwin_arm64.tar.gz"
      sha256 "046da369d69a6b2647091243865b6d4cea66c717f615524270f7fe8845ba20da"
    end
    on_intel do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_darwin_amd64.tar.gz"
      sha256 "36110217ba80053ad76dacd2eeed484316dd3588a379f0f7252cc1145f5fdf53"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_linux_arm64.tar.gz"
      sha256 "5126475f7229bb56b385f2d45961cb0a49e40ff7f92c1b315d6e7948c09fce7b"
    end
    on_intel do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_linux_amd64.tar.gz"
      sha256 "2df381e97359de38a3ef648e12cdd7794cab1a4bde1a469d11370a134bff460b"
    end
  end

  def install
    bin.install Dir["qqmail-cli*"].first => "qqmail-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qqmail-cli --version 2>&1", 1)
  end
end
