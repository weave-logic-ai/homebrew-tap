class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/WeftOS/weftos"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "51c23715042155b4dc2f7cf616dbacaf094d993e3b5bb02d63be4169d8671ebd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "7f40d8fdb27b0d78ffcb76990e5fcd3af4ade1c310c9b8ae660bc82bb406e5f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a157be4ea49298db8b7d0fe9fe2fa1c639f5c8ca4985849a14b7d9eac9cae70b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WeftOS/weftos/releases/download/v0.8.4/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0bd25acfca6979f667195c1ef457fa1fbb38ef317bae92ec79a6e6e88410f065"
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
      bin.install "git-remote-weftos", "weaver"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-remote-weftos", "weaver"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-remote-weftos", "weaver"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-remote-weftos", "weaver"
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
