class ClawftGuiEgui < Formula
  desc "egui/eframe native GUI spike for ClawFT — ports the 12 core UI blocks"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.6.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.20/clawft-gui-egui-aarch64-apple-darwin.tar.gz"
      sha256 "c8777287c29bfbb7af1fab4eae67aa2c5a3faf27e1be4259347e96b4ccad4d58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.20/clawft-gui-egui-x86_64-apple-darwin.tar.gz"
      sha256 "c23570068de76549b459011d9cf5020565f2c385c8ebd6e4e435568761823dc8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.20/clawft-gui-egui-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f0a7f9d38f3697988d9b9c2e89f5a63188ab20d782a7760c8245470e0ee5575f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.6.20/clawft-gui-egui-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d6a18ee7eef15413f2c0909a387ff72a4f30d10ac281bf299aab87f6c5e0774"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
    bin.install "weft-demo-lab", "weft-gui-egui" if OS.mac? && Hardware::CPU.arm?
    bin.install "weft-demo-lab", "weft-gui-egui" if OS.mac? && Hardware::CPU.intel?
    bin.install "weft-demo-lab", "weft-gui-egui" if OS.linux? && Hardware::CPU.arm?
    bin.install "weft-demo-lab", "weft-gui-egui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
