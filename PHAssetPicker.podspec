Pod::Spec.new do |s|
  s.name = "PHAssetPicker"
  s.version = "1.0.2"

  s.summary = "PHAsset Picker"
  s.homepage = "https://github.com/eugenebokhan/PHAssetPicker"

  s.author = {
    "Eugene Bokhan" => "eugenebokhan@protonmail.com"
  }

  s.ios.deployment_target = "12.3"

  s.source = {
    :git => "https://github.com/eugenebokhan/PHAssetPicker.git",
    :tag => "#{s.version}"
  }
  s.source_files = "Sources/**/*.{swift}"

  s.swift_version = "5.1"

  s.dependency "SnapKit"
end
