class Openvsp < Formula
  desc "Open Vehicle Sketch Pad is a parametric aircraft geometry tool"
  homepage "https://openvsp.org"
  url "https://github.com/OpenVSP/OpenVSP/archive/refs/tags/OpenVSP_3.36.0.tar.gz"
  sha256 "e568bba08e91bb9c6400848a3c3df206a892463f9e0385c6fda3b00ac51fd25c"
  license "NASA-1.3"

  depends_on "cmake" => :build
  depends_on "cminpack"
  depends_on "fltk"
  depends_on "glew"
  depends_on "glm"
  depends_on "libxml2"
  depends_on "python"
  depends_on "swig"

  on_macos do
    # Missing header include fl_ask
    # Upstream Issue is filed: https://github.com/OpenVSP/OpenVSP/issues/282
    patch :DATA
  end

  def install
    ENV.deparallelize # formula fails when building in parallel
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

    %w[vsp vspaero vspaero_adjoint vspaero_complex vspaero_opt vsploads vspscript vspviewer].each do |name|
      bin.install_symlink "#{prefix}/#{name}" => name
    end
  end

  test do
    system "#{prefix}/vsp", "--help"
  end
end

__END__
diff --git a/src/gui_and_draw/AdvLinkScreen.h b/src/gui_and_draw/AdvLinkScreen.h
index 932e052..814afe5 100644
--- a/src/gui_and_draw/AdvLinkScreen.h
+++ b/src/gui_and_draw/AdvLinkScreen.h
@@ -15,6 +15,7 @@
 #include "GuiDevice.h"
 
 #include <FL/Fl.H>
+#include <FL/Fl_ask.H>
 #include <FL/Fl_Text_Buffer.H>
 
 using std::string;
