class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "7a76e16ce2d913c7499f427a09bd578f418f0ecb55e3b3bdb5e884119ce1ba64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "f331fbd3486ece9c75b2da6d59d39fb30b55c3d062e7ad4724b2fff5cc0fdf5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0285942d0f490ee4a8efcf53a1a8c5e324b06822e9c03090fb595bd43e94f62a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.2.0/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "85f2fb6605cf611f025d17dcbf7de419dbdcd69e48973389586af91ee57498c2"
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
