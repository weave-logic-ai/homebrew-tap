class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.6.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "eae510528f239bcf0abc8220eb48cc976be214cda5491104a617743eecf7bc68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "8a86de5887d6d1610149ae18d189d4cccd8a7a29138a78b61425a2dc6bb9eb52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d4cbe304cf1186d3ae2fda43d13293ccab948a0fbf7c0aa78f54ea499696fb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f3b61c7b9b406cbb021fd2e274267a38e1635363cb7980f716e87f118fa60890"
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
