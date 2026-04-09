class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "42067de470c54094099e2b91e1ceb7400a4aecbd1784996ab17e90b9b84ab35b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "acac7de6b21365c0bc6171a39d67694a9b9006a05bcff1f473cc17a59cfd2777"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe2b978751a851175c39a9991a4927ed8c4c2eec93d2fcdc8158c3d543e35ec8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.4/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43c1f830ab85219ff90b68b435cfbb95de5a51c35a3d0ac6e463061e790bee64"
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
