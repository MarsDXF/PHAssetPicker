Pod::Spec.new do |s|
  s.name = "SimpleImagePicker"
  s.version = "1.0.0"

  s.summary = "Simple Image Picker"
  s.homepage = "https://github.com/eugenebokhan/SimpleImagePicker"

  s.author = {
    "Eugene Bokhan" => "eugenebokhan@protonmail.com"
  }

  s.ios.deployment_target = "12.3"

  s.source = {
    :git => "https://github.com/eugenebokhan/SimpleImagePicker.git",
    :tag => "#{s.version}"
  }
  s.source_files = "Sources/**/*.{swift}"

  s.swift_version = "5.1"

  s.dependency "SnapKit"
end
