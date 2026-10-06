class ClawftGuiEgui < Formula
  desc "egui/eframe native GUI spike for ClawFT — ports the 12 core UI blocks"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-gui-egui-aarch64-apple-darwin.tar.gz"
      sha256 "1e07ac294171b07bd3e19697f5d973cfe7728b7aa49d38ea64f77403fdf6bd34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-gui-egui-x86_64-apple-darwin.tar.gz"
      sha256 "de5ec103ef434440b38f3f982ddf903eacb8ec97c455e94274b38b6bd649db6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-gui-egui-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2e64e9fe66d5d491d7e1b8f5c8e36e9646fc7373ee1101caec45f0fe87dcfdd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-gui-egui-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f31dca97c7a535d051adf892e61cc799323decd5fee0814aa7739e84b8b568ad"
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
