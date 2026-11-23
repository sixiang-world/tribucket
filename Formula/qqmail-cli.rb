class QqmailCli < Formula
  desc "Unofficial safety-first QQ Mail CLI for scripts and AI agents"
  homepage "https://github.com/sixiang-world/qqmail-cli"
  version "0.6.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.6.0/qqmail-cli_0.6.0_darwin_arm64.tar.gz"
      sha256 "e7978e059ea362ec9fd668a9db5882edb9144431d8adbe9249d3b2bab2f300b4"
    end
    on_intel do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.6.0/qqmail-cli_0.6.0_darwin_amd64.tar.gz"
      sha256 "30ed9b3ad0be525775bff0008c952cde95724e6ac4e459b1cdae5af26a45b691"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.6.0/qqmail-cli_0.6.0_linux_arm64.tar.gz"
      sha256 "f376c2606feb77246cc3618fef9057aca75f823b2b327b07868cfd6fe8797b88"
    end
    on_intel do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.6.0/qqmail-cli_0.6.0_linux_amd64.tar.gz"
      sha256 "c81eef60ebc545ee3b7e49226540a528bc22aafb9538726c1ae12ff1c6fb0106"
    end
  end

  def install
    bin.install Dir["qqmail-cli*"].first => "qqmail-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qqmail-cli --version 2>&1", 1)
  end
end
