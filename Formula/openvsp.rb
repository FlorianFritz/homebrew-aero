# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Openvsp < Formula
  desc "OpenVSP is a parametric aircraft geometry tool. OpenVSP allows the user to create a 3D model of an aircraft defined by common engineering parameters."
  homepage "https://openvsp.org"
  url "https://github.com/OpenVSP/OpenVSP/archive/refs/tags/OpenVSP_3.35.3.tar.gz"
  sha256 "e08827bd8848ba75fc7466bcec399aa785683335e81c0e24773b0bf0e68de216"
  license "NASA OPEN SOURCE AGREEMENT VERSION 1.3"

  version "3.35.3"

  depends_on "cmake" => :build
  depends_on "cminpack"
  depends_on "fltk"
  depends_on "glm"
  depends_on "glew"
  depends_on "libxml2"
  depends_on "python"
  depends_on "swig"
  
  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", "-S", "#{buildpath}/Libraries", "-B", "build_libs", *std_cmake_args,
                    "-DVSP_USE_SYSTEM_LIBXML2=true",
                    "-DVSP_USE_SYSTEM_FLTK=true",
                    "-DVSP_USE_SYSTEM_GLM=true",
                    "-DVSP_USE_SYSTEM_GLEW=true",
                    "-DVSP_USE_SYSTEM_CMINPACK=true",
                    "-DVSP_USE_SYSTEM_LIBIGES=false",
                    "-DVSP_USE_SYSTEM_EIGEN=false",
                    "-DVSP_USE_SYSTEM_CODEELI=false"
    system "cmake", "--build", "build_libs"

    system "cmake", "-S", "#{buildpath}/src", "-B", "build_vsp", *std_cmake_args,
                    "-DVSP_LIBRARY_PATH=#{buildpath}/build_libs"
                                                      
    system "cmake", "--build", "build_vsp"
    system "cmake", "--install", "build_vsp"

    [
      "vsp",
      "vspaero",
      "vspaero_adjoint",
      "vspaero_complex",
      "vspaero_opt",
      "vsploads",
      "vspscript",
      "vspviewer",
    ].each do |name|
      #(HOMEBREW_PREFIX/"bin").install_symlink name
      bin.install_symlink (prefix/"#{name}").realpath => name
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test openvsp`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
