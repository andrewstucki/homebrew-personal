class Wangle < Formula
	desc "Wangle is a framework providing a set of common client/server abstractions for building services in a consistent, modular, and composable way."
	homepage "https://github.com/facebook/wangle"
	url "https://github.com/facebook/wangle/archive/v2017.11.06.00.tar.gz"
	sha256 "c85b3ae65d78c1fa2027d14bcb3623fc5619c766514512861ce2b1e90bd72c65"

	depends_on "cmake" => :build
	depends_on "openssl"
	depends_on "folly"

	def install
		cd "wangle" do
			system "cmake", ".", "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}", *std_cmake_args
			system "make", "install"
		end
	end

	test do
		system "false"
	end
end
