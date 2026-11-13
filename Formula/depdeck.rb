class Depdeck < Formula
  desc "Turn direct npm dependencies into a trading-card deck"
  homepage "https://github.com/pragatikumari0927/depdeck"
  url "https://github.com/pragatikumari0927/depdeck/archive/refs/tags/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "975d5738f435c43dee6ec3e483b737ba3f0c20bce1a0ab422f0f0255cd87715a"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pragatikumari0927/depdeck/pkg/types.BuildVersion=#{version}"
    system "go", "build", "-trimpath", "-buildvcs=false", "-ldflags", ldflags,
           "-o", bin/"depdeck", "./cmd/depdeck"
    pkgshare.install "THIRD_PARTY_NOTICES.txt"
  end

  test do
    require "json"
    assert_equal "depdeck #{version}", shell_output("#{bin}/depdeck --version").strip
    (testpath/"package.json").write("{}")
    assessment = JSON.parse(shell_output("#{bin}/depdeck check --json"))
    assert_equal "depdeck #{version}", assessment["generated_by"]
    assert_equal "empty_roster", assessment["data"]["reason"]
  end
end