class Proxygen < Formula
	desc "A collection of C++ HTTP libraries including an easy to use HTTP server."
	homepage "https://github.com/facebook/proxygen"
	url "https://github.com/facebook/proxygen/archive/v2017.11.06.00.tar.gz"
	sha256 "5123d628ff7de1fbd92948d0c9e19c6799f28521956d22c6cb1dfa9b7b4c6b1c"

	depends_on "autoconf" => :build
        depends_on "libtool" => :build
	depends_on "automake" => :build
	depends_on "autoconf-archive" => :build
	depends_on "openssl"
	depends_on "folly"
	depends_on "wangle"
	depends_on "boost"

	patch :p0, <<-EOS.undent
		--- proxygen/configure.ac
		+++ proxygen/configure.ac
		@@ -206,7 +206,7 @@
		 fi

		 LIBS="$LIBS $BOOST_LDFLAGS -lpthread -pthread -lfolly -lglog"
		-LIBS="$LIBS -ldouble-conversion -lboost_system -lboost_thread"
		+LIBS="$LIBS -ldouble-conversion -lboost_system -lboost_thread-mt"

		 AM_CONDITIONAL([HAVE_STD_THREAD], [test "$ac_cv_header_features" = "yes"])
		 AM_CONDITIONAL([HAVE_X86_64], [test "$build_cpu" = "x86_64"])
	EOS

	patch :p0, <<-EOS.undent
		--- m.am	2017-11-10 22:30:33.000000000 -0600
		+++ proxygen/lib/test/Makefile.am	2017-11-10 22:44:08.000000000 -0600
		@@ -3,7 +3,7 @@
		 BUILT_SOURCES = googletest-release-1.8.0/googletest/src/gtest-all.cc
 
		 release-1.8.0.zip:
		-	wget https://github.com/google/googletest/archive/release-1.8.0.zip
		+	curl -L -O https://github.com/google/googletest/archive/release-1.8.0.zip
		 
		 # The SHA1 test is in a separate rule from the fetch, because otherwise
		 # `make` would run `sha1sum` **before** wget.  We'd re-extract the archive
	EOS

	patch :p0, <<-EOS.undent
		--- proxygen/lib/test/Makefile.am
		+++ proxygen/lib/test/Makefile.am
		@@ -9,7 +9,7 @@
		 # `make` would run `sha1sum` **before** wget.  We'd re-extract the archive
		 # without `touch`, since the contents' timestamps are older than the zip's.
		 googletest-release-1.8.0/googletest/src/gtest-all.cc: release-1.8.0.zip
		-	[ "$(shell sha1sum release-1.8.0.zip | awk '{print $$1}')" == \\
		+	[ "$(shell shasum release-1.8.0.zip | awk '{print $$1}')" == \\
		 	    "667f873ab7a4d246062565fad32fb6d8e203ee73" ]
		 	unzip release-1.8.0.zip
		 	touch googletest-release-1.8.0/googletest/src/gtest-all.cc
	EOS

	def install
		cd "proxygen" do
			system "autoreconf", "-ivf"

			ENV["LDFLAGS"] = "-L#{Formula["openssl"].opt_lib} -L#{Formula["folly"].opt_lib} -L#{Formula["wangle"].opt_lib}"
			ENV["CPPFLAGS"] = "-I#{Formula["openssl"].opt_include} -I#{Formula["folly"].opt_include} -I#{Formula["wangle"].opt_include}"

			system "./configure", "--prefix=#{prefix}"
			system "make", "install"
		end
	end

	test do
		system "false"
	end
end
