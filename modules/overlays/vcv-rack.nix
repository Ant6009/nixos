self: super: {
  vcv-rack = super.vcv-rack.overrideAttrs (oldAttrs: rec {
    version = "2.6.4";
    
    src = super.fetchFromGitHub {
      owner = "VCVRack";
      repo = "Rack";
      rev = "v${version}";
      sha256 = ""; # Leave empty initially
    };
  });
}
