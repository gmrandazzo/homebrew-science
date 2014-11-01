require "formula"

class Avogadro < Formula
  homepage "http://avogadro.cc/"
  url "https://downloads.sourceforge.net/project/avogadro/avogadro/1.1.1/avogadro-1.1.1.tar.bz2"
  sha1 "e89b5cb9456149ca1de38ff0204bc4a96a73e9db"

  head "https://github.com/cryos/avogadro.git"

  depends_on "boost" => "c++11"
  depends_on "boost-python" => "c++11"
  depends_on "cmake" => :build
  depends_on "eigen2" # avogadro depends on eigen >= 2.x. Tap homebrew-version
  depends_on "open-babel" => "with-python" # avogadro depends on open-babel >= 2.3.x
  depends_on "qt"

  stable do
    # Fix for Parse error at "BOOST_JOIN"
    patch do
      url "https://raw.githubusercontent.com/zeld/patch/master/avogadro-1.1.1-BOOST_JOIN-fix.patch"
      sha1 "c6510666ac56934d0a967eabc44df348ab166a73"
    end
  end

  # Fix the OSX installation path
  patch do
    url "https://raw.githubusercontent.com/zeld/patch/master/avogadro-cmake_install-path-fix.patch"
    sha1 "4ddc7b69b41efe49678a95e0982eee9c117f7336"
  end

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DPYTHON_LIBRARY=#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib"
      args << "-DPYTHON_INCLUDE_DIR=#{%x(python-config --prefix).chomp}/include/python2.7/"
      args << "-DEIGEN2_INCLUDE_DIR=#{Formula["eigen2"].opt_include}/eigen2/"
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end

  test do
    system "#{prefix}/Avogadro.app/Contents/MacOS/Avogadro", "--version"
  end
end
