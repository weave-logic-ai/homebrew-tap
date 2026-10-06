class ClawftWeave < Formula
  desc "WeftOS operator CLI (weaver) — kernel management, services, and agent orchestration"
  homepage "https://github.com/weave-logic-ai/weftos"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-weave-aarch64-apple-darwin.tar.gz"
      sha256 "72353b69484649b7b0e29527aa3f136af27792795d7af24b6176431e0335dca5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-weave-x86_64-apple-darwin.tar.gz"
      sha256 "b2adf841eb96fec0d8b1be2f077336f163ea8be8b336c0ed3c17d43bfa3c78e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-weave-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d1068d6a8a76b2e45a3825704de61d85c096dbe07b0408fd3aedba743974290d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/weave-logic-ai/weftos/releases/download/v0.8.3/clawft-weave-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e12b2d733b1a5678d4b746e36932679815c74e3f9d1d8cbfcb110f24be76cc25"
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
