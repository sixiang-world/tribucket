class Gradle < Formula
  desc "Build automation tool for JVM projects"
  homepage "https://gradle.org/"
  version "8.14"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://services.gradle.org/distributions/gradle-8.14-bin.zip"
      sha256 "61ad310d3c7d3e5da131b76bbf22b5a4c0786e9d892dae8c1658d4b484de3caa"
    end
    on_intel do
      url "https://services.gradle.org/distributions/gradle-8.14-bin.zip"
      sha256 "61ad310d3c7d3e5da131b76bbf22b5a4c0786e9d892dae8c1658d4b484de3caa"
    end
  end

  on_linux do
    on_arm do
      url "https://services.gradle.org/distributions/gradle-8.14-bin.zip"
      sha256 "61ad310d3c7d3e5da131b76bbf22b5a4c0786e9d892dae8c1658d4b484de3caa"
    end
    on_intel do
      url "https://services.gradle.org/distributions/gradle-8.14-bin.zip"
      sha256 "61ad310d3c7d3e5da131b76bbf22b5a4c0786e9d892dae8c1658d4b484de3caa"
    end
  end

  def install
    bin.install Dir["gradle*"].first => "gradle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version 2>&1", 1)
  end
end
