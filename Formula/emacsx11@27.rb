class Emacsx11AT27 < Formula
  desc "GNU Emacs text editor X11"
  homepage "https://www.gnu.org/software/emacs/"
  version "27.2"
  url "https://github.com/emacs-mirror/emacs/archive/refs/tags/emacs-"+version+".tar.gz"
  sha256 "648cb8f9298a17de0770fad8dc5d96d8ca135c41cd3ddcaa65523e3be37c6728"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/emacs-mirror/emacs.git", :branch => "emacs-27"
  end
  
  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build
  depends_on "texinfo" => :build
# build for build time dependency
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libxaw"
  depends_on "libx11"
  depends_on "libtiff"
  depends_on "libjpeg"
  depends_on "libxcb"
  depends_on "libxt"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "cairo"
  depends_on "freetype" => :recommended
  depends_on "fontconfig" => :recommended

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"


  on_linux do
    depends_on "jpeg"
  end

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https://github.com/Homebrew/homebrew-core/issues/46393
    # https://github.com/Homebrew/homebrew-core/pull/70421
    ENV.append "LDFLAGS", "-lfreetype -lfontconfig"
    args = %W[
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --with-xml2
      --without-dbus
      --with-modules
      --without-ns
      --without-imagemagick
      --without-selinux
      --with-x
      --with-cairo
      --with-gif=no
      --with-tiff=no
      --with-jpeg=no
    ]

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    system "./autogen.sh"

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
