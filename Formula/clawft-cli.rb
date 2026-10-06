class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "40aee60416a700938fc9c620bbec2c808f5043a1fb7298ce4aa31499eba5b600"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "24f37f3ce601f2e3790e7f56c271aaff45129915b71fa6386bcd2cee1e71df46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0af134ebf8146c01da8ede5d352c867537cd19419ef159c19815e7c5cfe9c02c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a4dd4597ffc1aef28bed516c0982ed5148c8db9dcafdb18403fcdbff57f2e6b"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "weft"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "weft"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "weft"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "weft"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
