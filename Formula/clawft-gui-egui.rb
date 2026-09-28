class ClawftGuiEgui < Formula
  desc "egui/eframe native GUI spike for ClawFT — ports the 12 core UI blocks"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-gui-egui-aarch64-apple-darwin.tar.gz"
      sha256 "44e24b4fe4c76a1f2f7549c73aefcaf639b2c1887be5826df9b6dadc752d5cbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-gui-egui-x86_64-apple-darwin.tar.gz"
      sha256 "58bc62e96988c8d69255ce1119f76d67fea4dd1a2e5ef296f6953ac335ed8407"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-gui-egui-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d0dcdb0dba19301e62ce1584445fe25c7c8e706a22661b8789b352ae3660b514"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-gui-egui-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "76a2c3e19ac4eabdc12ea680d981f4759796508e63814ce04ebb0804f4de26c0"
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
