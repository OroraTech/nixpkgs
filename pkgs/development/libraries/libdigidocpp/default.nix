{ lib, stdenv, fetchurl, cmake, makeWrapper, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkg-config, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.14.8";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     sha256 = "sha256-U5i5IAyJF4359q6M6mQemEuG7+inPYIXqLy8GHv4dkg=";
  };

  nativeBuildInputs = [ cmake makeWrapper pkg-config xxd ];

  buildInputs = [
    minizip pcsclite opensc openssl xercesc
    xml-security-c xsd zlib xalanc
  ];

  # replace this hack with a proper cmake variable or environment variable
  # once https://github.com/open-eid/cmake/pull/34 (or #35) gets merged.
  postInstall = ''
    wrapProgram $out/bin/digidoc-tool \
      --prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/
  '';

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
