class Weftos < Formula
  desc "WeftOS: A portable AI kernel with process management, mesh networking, and cognitive substrate"
  homepage "https://github.com/WeftOS/weftos"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/weftos-aarch64-apple-darwin.tar.gz"
      sha256 "b5a735ef0e445cfca55ae9dd9376e008f3fe92e87b11b9c2a863463458a0433e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/weftos-x86_64-apple-darwin.tar.gz"
      sha256 "4771d916f7970ab65bc0061c3c683b78725f2ec35534404b75a8540d515b3ba9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/weftos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a27519029091acad386eabe0a03a6bc76d2ef3c79cdfc514f67f82463d6011a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/weftos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "15f7c10aee6226b64de84e2337e4d2011fc043556ab0da95cad96a8390cbf06f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
