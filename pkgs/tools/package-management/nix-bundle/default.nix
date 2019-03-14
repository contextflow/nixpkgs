{ stdenv, lib, fetchFromGitHub, nix, makeWrapper, coreutils, gnutar, gzip, bzip2 }:

stdenv.mkDerivation rec {
  pname = "nix-bundle";
  name = "${pname}-${version}";
  #version = "0.3.0";
  version = "0.3.0+fix";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = pname;
    #rev = "v${version}";
    rev = "e65faad14f3becad4d8bd1db14f1287dd23ac1f3";
    sha256 = "1crmg53qkpsvx0kczcldrwr5nhc8d05wfcjq0dn3bwxmmmgria7i";
  };

  # coreutils, gnutar is actually needed by nix for bootstrap
  buildInputs = [ nix coreutils makeWrapper gnutar gzip bzip2 ];

  binPath = lib.makeBinPath [ nix coreutils gnutar gzip bzip2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/share/nix-bundle/nix-bundle.sh $out/bin/nix-bundle \
      --prefix PATH : ${binPath}
    cp $out/share/nix-bundle/nix-run.sh $out/bin/nix-run
  '';

  meta = with lib; {
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.all;
    description = "Create bundles from Nixpkgs attributes";
    license = licenses.mit;
    homepage = https://github.com/matthewbauer/nix-bundle;
  };
}
