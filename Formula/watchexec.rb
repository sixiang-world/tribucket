class Watchexec < Formula
  desc "Execute commands in response to file modifications"
  homepage "https://github.com/watchexec/watchexec"
  version "2.5.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.5.1/watchexec-2.5.1-aarch64-apple-darwin.tar.xz"
      sha256 "c5e405dd1109940b2510398d2182990c1be59063b94e11d7ace9c7b435cb1df1"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.5.1/watchexec-2.5.1-x86_64-apple-darwin.tar.xz"
      sha256 "bb74bf33286ff7f31dd8e763e017fbc0418360d88baefd35bc57d662d28394e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.5.1/watchexec-2.5.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "217e564946fec9911279c455e174e938d497480792a342c28712e50346cc0140"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.5.1/watchexec-2.5.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cafc381f74e95f8e93e796ef590c7cbbf3409dda6d56cf3dee6109c10e5188ee"
    end
  end

  def install
    bin.install Dir["watchexec*"].first => "watchexec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchexec --version 2>&1", 1)
  end
end
