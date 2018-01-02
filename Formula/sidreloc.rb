class Sidreloc < Formula
  desc "Tool for relocating SID tunes any number of whole pages"
  homepage "https://www.linusakesson.net/software/sidreloc/"
  url "https://hd0.linusakesson.net/files/sidreloc-1.0.tgz"
  sha256 "8ca55fb4886bda2a499f837e2f9ffd0a4b7217ee7bb1907ceed9e87ef6157bf6"

  def install
    system "make"
    bin.install "sidreloc"
  end

  test do
    system "#{bin}/sidreloc", "-h"
  end
end

