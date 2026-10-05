class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "7d94e19816320ccd2c7cdef36ad9a491a746b8c3896dbd9ca5c051b553dd6397"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "6bd6aaa4659045893d052175a115dac6430ed6cf539b4448c63cbe6e80caa24a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6f058d98a9a87e4105b7038590b5ce90a674aea92479d196c691f9c566a4651e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7d11c1a8c00b6acd8e27f6cfb04732cae371f94f9806ec3780558208fa70988"
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
