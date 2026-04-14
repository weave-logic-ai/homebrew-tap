class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.4/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "99bbb1dd861da5525c00588b942d01d7921303e5d27fb823b7c2688f786ec2c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.4/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "2908fd97b81a59af6c201ed375c406cd3f0dc383afa8d5906d92662e321ddc68"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.4/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2fce489c9a3c58a856d1b5a40c5ba315e69231fb0bf27a62e814c496b2cfb59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.4/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dad3366bc75d54d577d6675665420f75363c04fafe97d80f53c1c12337e10634"
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
