class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "70aaf4739c550066b62eeeccd05c4607af685a65add7d793f7bda90d05be61b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "ccfb12757cbbb9d96d7e5b8e203f6122e338b623ae8b144783e87984d8b47600"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d635f590bffb737c8283d3cb7590854b74be5671afba5e765358ff793607922f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cdfe75a0a97e56e19199c5be006bea3e7e4b4caaa7a3133e46085be78b911e46"
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
