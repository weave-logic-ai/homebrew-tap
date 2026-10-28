class ClawftGuiEgui < Formula
  desc "egui/eframe native GUI spike for ClawFT — ports the 12 core UI blocks"
  homepage "https://github.com/WeftOS/weftos"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-gui-egui-aarch64-apple-darwin.tar.gz"
      sha256 "e1f2fb982179d60cb26238a8629678429475c239739ec5acac8354f094cfb620"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-gui-egui-x86_64-apple-darwin.tar.gz"
      sha256 "d69318eb9736befc2601d88a1757d79489f9283cf8c1898af67d74dde1781ae1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-gui-egui-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "76e3677b7f9d351c123e50a1f0046da184b6318ba97705e15312950a5e41ad27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-gui-egui-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a68730788f562270ed7ab196d2de987aef51e60dcb1754ea747e9fb249e1979"
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
      bin.install "weft-gui-egui"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "weft-gui-egui"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "weft-gui-egui"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "weft-gui-egui"
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
