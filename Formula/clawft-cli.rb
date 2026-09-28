class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "ee33cd687054a5abdd01ac93454b5dfccaec96b5bd3430bf175778378927749b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "dae8fa2e1177bf256e7bd685af5873b342c47e0b2c0897ac09198165cd16d78d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9aac011a4ef892201328f044813ef56f550681edfd79cf3ada2931c890ab8eff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29b0de7cf923b87d0fa50003fcc00c1a00b3b0ff4b82994f4eb556faf88674ee"
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
