class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "73ca45077de5cd687b84f92a4baa1f4731a449b2345ee198f41a7a8243b560a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "ed5f52abe3d226f4c0fa6765480e80d93492351785f1041e3a736230d70a9b1b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9dccbe13517f3d098500b1b745c1f4215a6aaadff5892375c18cbb735d6d8c28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cc2eecf8ce044c6a758be3d806e04aceabecaa851189af3b58a8e8e0291faafb"
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
