class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "96d963402611828b66a548e4fc98ab62cdf89e28f760621d73c6b5217a2c3d3e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "126a5263420fa009599100c52617c6ed0220a5959edf8a155a125751990f776a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d368464a4d9517835274186b02594e9fbe14d66001c636e672aee23d1c899f50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "232c209ac5062e554e0ebc0c36f6f7232d338c76d9a4909110b52862e2b5b2f0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "weaver" if OS.mac? && Hardware::CPU.arm?
    bin.install "weaver" if OS.mac? && Hardware::CPU.intel?
    bin.install "weaver" if OS.linux? && Hardware::CPU.arm?
    bin.install "weaver" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
