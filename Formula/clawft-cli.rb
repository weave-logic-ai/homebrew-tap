class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.6.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "16d9efe7ecde820bcc0bf328a0588395d99239bf6d038f11084dfe8f10298379"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "bbb3929c081c6ef9da168b7c10e877d8fac4966ac87b3ab4f9222aea34c0594d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b8054788bd6584e248aeedf15f0a15ae9cfbbc2b3a1a2e5eca5944f1bba418ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.15/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "802261d6212cfa4fe3b3756ec78cafb7fc926a6985f861714bfb5be81a01dcf1"
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
    bin.install "weft" if OS.mac? && Hardware::CPU.arm?
    bin.install "weft" if OS.mac? && Hardware::CPU.intel?
    bin.install "weft" if OS.linux? && Hardware::CPU.arm?
    bin.install "weft" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
