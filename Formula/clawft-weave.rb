class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "4697da7a91d40fb131928473ed8f402792500b8446d442d4c8a60784f257d66a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "0fde279d95e33979be3f7a2720785ee76850027dd6fa18162c0e6463b496f8a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "903ecddd9a5fbd6d494c68a883b9fd6ac614d39893ad0cc58be22c3958917f7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.1/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ef2c95dd756c411c6213928f0e7481f0613eb99af6749cfeece1b5025cb2e27b"
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
      bin.install "weaver"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "weaver"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "weaver"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "weaver"
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
