class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c485bf4756abd7da15b59b827b02ce7b0f3669573b6d3f4e2a8c1aa4bcb6b8c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "6f85d5fe1a8b76bcd1c31c391d3df0ba109c314ab1949362ed0f90110ccf7c3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2310998d0a7c41f49698e3fc735e67620976138dbca320fcd5909fff07f5758f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.4.0/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "584f6b5fc0d6f893c24bc84ac53e5e61cd17019290c44a381dad35f6946c4b9e"
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
