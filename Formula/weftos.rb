class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "53fb5ef9dabd4106045d6f88ba298ac5c0c9f9d07ba3c5487e71ef12fd015ac0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "c7dbca9b724f65c668772612b9d4b9a8021ce2a0db92405ab756771d1c9a5be2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9bb09f37faf639dfb7bf162be4cafee435c203d7428a2476bd9280997d1b9ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "524742e2105121484b5f671b60c8bac56a2cf212898a33978ca96ccc47994930"
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
      bin.install "weftos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "weftos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "weftos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "weftos"
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
