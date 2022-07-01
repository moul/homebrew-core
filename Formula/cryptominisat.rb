class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.8.0.tar.gz"
  sha256 "50153025c8503ef32f32fff847ee24871bb0fc1f0b13e17fe01aa762923f6d94"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0080bcccfef680ad5ce255c0db41cf317a128d806190cb0f3cf77db977f2895f"
    sha256 cellar: :any,                 arm64_big_sur:  "0d75d03ed589f74e2e7cbe49e8bc346eabfc5f0a75f53be9669d59f692b24563"
    sha256 cellar: :any,                 monterey:       "2eb8815c19cc6b5ce0f68f4c262ce5e4a124c38bd182ef6d218d4350201ec409"
    sha256 cellar: :any,                 big_sur:        "da133a50cb64de5b467286c0b588166847553fc6230622c694b74dcb478ea7fc"
    sha256 cellar: :any,                 catalina:       "68b206ea8da094838cfcc4cf286bcedd8c0a876015caed0df32bfa3d16d728b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33b451222b7bf0bf6deff969bb7910af331b192e37746375938bb6eacf257200"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "python@3.10"

  # Fix build error with setuptools 61+
  patch do
    url "https://github.com/msoos/cryptominisat/commit/a01179ffd6b0dd47bfdef2d9350d80b575571f24.patch?full_index=1"
    sha256 "a75998d5060d1de13f2173514b85b2c3ce13ad13085ef624b0d711e062fc6289"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # fix building C++ with the value of PY_C_CONFIG
    inreplace "python/setup.py.in", "cconf +", "cconf + ['-std=gnu++11'] +"

    # fix error: could not create '/usr/local/lib/python3.10/site-packages/pycryptosat.cpython-310-darwin.so':
    # Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3")
    inreplace "python/CMakeLists.txt",
              "COMMAND ${PYTHON_EXECUTABLE} ${SETUP_PY} install",
              "COMMAND ${PYTHON_EXECUTABLE} ${SETUP_PY} install --install-lib=#{site_packages}"

    system "cmake", "-S", ".", "-B", "build",
                    "-DNOM4RI=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~EOS
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    EOS
    assert_equal "(None, True, False, True)\n", shell_output("#{Formula["python@3.10"].opt_bin}/python3 test.py")
  end
end
