class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.1.2/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "dfa2a058921ba2925c8abdeb1b46cdc639cdc81a50182e3a1173a52cd183282d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.1.2/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "bb5d2f420b1d4dbcae9d801d864baedc1a42c0f9707d644b3c59ec452295a53b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.1.2/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "980e29a0c1d8d7d4abb871720eb7fe4cca26e32d453b749002206935b7891d6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.1.2/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aceb2a275bea63a03ce58f9c2975e984a5d71785647739b2917ec9dbc2e132f4"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
