class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "29b24c9035efc434cbe8a5f5ec7ea664e8a119c88e976821ffe65a6e172b0dbd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "4cb439c7afc7fdd55d7bf21b21ccf392cc73361f0f5a9532a37583404aa3f04e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bafd0e6be83c85ca0d7b1679b66bff4b06ead7ee772b3972148871803d7aa118"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1d0462918c826e6e860e6027d68224f194c854df945636191ceebd9a49ad3a66"
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
