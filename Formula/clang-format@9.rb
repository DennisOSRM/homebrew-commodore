class ClangFormatAT9 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"

  stable do
    url "http://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz"
    sha256 "d6a0565cf21f22e9b4353b2eb92622e8365000a9e90a16b09b56f8157eabfe84"

    resource "clang" do
      url "http://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz"
      sha256 "7ba81eef7c22ca5da688fdf9d88c20934d2d6b40bfe150ffd338900890aa4610"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  resource "libcxx" do
    url "http://releases.llvm.org/9.0.0/libcxx-9.0.0.src.tar.xz"
    sha256 "3c4162972b5d3204ba47ac384aa456855a17b5e97422723d4758251acf1ed28c"
  end

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      add_suffix "bin/clang-format", 9
      bin.install "bin/clang-format-9"
    end
    add_suffix "tools/clang/tools/clang-format/git-clang-format", 9
    bin.install "tools/clang/tools/clang-format/git-clang-format-9"
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-9 -style=Google test.c")
  end
end
