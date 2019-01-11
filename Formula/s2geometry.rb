class S2geometry < Formula
  desc "S2 is a library for spherical geometry"
  homepage "http://s2geometry.io"
  url "https://github.com/google/s2geometry.git"
  version "0.0"
  sha256 "d549fa5aa7653b1d17d184835417e6419facbbc9a1404d6a5fb9cfc324180fe8"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl" => :build

  resource "gtest" do
  	url "https://github.com/google/googletest/archive/release-1.8.1.zip"
  	sha256 "927827c183d01734cc5cfef85e0ff3f5a92ffe6188e0d18e909c5efebf28a0c7"
  end

  def install
	ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].include

	(buildpath/"gtest").install resource ("gtest")
	(buildpath/"gtest/googletest").cd do
	  system "cmake", "."
	  system "make"
	end
	ENV["CXXFLAGS"] = "-I../gtest/googletest/include"


    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "install"
    end
  end

  test do
    system "ninja", "test"
  end
end
