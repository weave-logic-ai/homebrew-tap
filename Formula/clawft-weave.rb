class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "af2535061c1c72b12e558371afb1915b74f6440e12435b40260a1cd0c914d16b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "249a9ef4f77bd61609d70ecb7d0be29e4f20953bb627ddaac2681c65aea62adb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b8fbd7f37f34e3f968ab23c2648e4dc561d63033d5317599921318b8a9443f4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.5.3/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38be6ad7bf7bb7d1d50bbdc748fffeb42d5afcf70d26cfe53f73284fbb6fa910"
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
    bin.install "weaver" if OS.mac? && Hardware::CPU.arm?
    bin.install "weaver" if OS.mac? && Hardware::CPU.intel?
    bin.install "weaver" if OS.linux? && Hardware::CPU.arm?
    bin.install "weaver" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
