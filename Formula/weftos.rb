class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.6.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.9/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "b46b797f96d2644849b70306918753c41f3a3e16f257391bfda4475add37f3f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.9/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "fcedadd734055d08a0572bf537313c6dd3ed2b18f154be34fd540a0b6be4060d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.9/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ebd84a15b41c806e801923b4aed070f51f12523d0439722ae97e926ac30dfcc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.9/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "95b148c87d56542c64488ad9481fb7302b6cba5b55ef81efa099063ca61e8c40"
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
    bin.install "weftos" if OS.mac? && Hardware::CPU.arm?
    bin.install "weftos" if OS.mac? && Hardware::CPU.intel?
    bin.install "weftos" if OS.linux? && Hardware::CPU.arm?
    bin.install "weftos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
