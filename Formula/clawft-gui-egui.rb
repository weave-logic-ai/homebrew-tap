class ClawftGuiEgui < Formula
  desc "egui/eframe native GUI spike for ClawFT — ports the 12 core UI blocks"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-gui-egui-aarch64-apple-darwin.tar.gz"
      sha256 "cee4ce5890de649fb499007cd9a99e438ae19ed363e0a7b73437f3aa3b01dd8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-gui-egui-x86_64-apple-darwin.tar.gz"
      sha256 "afd026ee1cd7c6d6963f972f2124ac7eb52221560b0c1dcf028a398a5626ee51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-gui-egui-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "968ed15521d856abc1122a917308ca362a464708f135873eb8e8727fd0ac93a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.2/clawft-gui-egui-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c9989298bd184b34b9f966f661562af869617080034761d07220b8c265e7d38"
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
