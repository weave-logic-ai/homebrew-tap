class ClawftCli < Formula
  desc "CLI binary (weft) for clawft"
  homepage "https://github.com/WeftOS/weftos"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-cli-aarch64-apple-darwin.tar.gz"
      sha256 "b7e33589d6be8629ff9ce28385fd69cf791d5c0d1c3abdf3c0ea7b0cbff8f80c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-cli-x86_64-apple-darwin.tar.gz"
      sha256 "4b948986642bf020c2241bca394c485f885570c195b50d795bffbc307e596d9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1224c6f1e99cd15890b0a0b84c77b2278aa74fac56fc13eda0068e0802c17448"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7985de4343fac6098e68c50b80b4526cba5b9a9782edb24ac963c8e9adb07dbc"
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
