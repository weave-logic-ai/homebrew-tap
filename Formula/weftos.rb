class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "0bf4d8ac321f207da794f67dbcaa00ced06a1afa39767e25aa5bacd417414b9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "5957f8bade70d1f43696ed86cd8b7179122308fdfd144dcd245126b783a424b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "31659e40031f0d8790e646c006f6921a2fb84ab98b5665e039e943151c00d261"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "73c77ed2db234209ca5712ab1273a3a7ac58ba9cd009d46d0d977d908d875f90"
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
