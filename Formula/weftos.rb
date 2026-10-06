class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "53c9fb34d57b16dc22d7b18921a2d226bb4d3ed5e763a0f3dd36e967aa43fb39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "1421b21b5ef9cbe1f9273609690a82eae383d0e3ad21412a4a5c7714071836a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "50ada9f1c6fc92e98b98f6a46fcb16f8c3eaacc664aaf2bcb0cf07a8789b15f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2c13c679a4e9aa4b1d5bb1f3aef8826d62d499ad597cb0c7976382bb8a27565"
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
