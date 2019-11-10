Pod::Spec.new do |spec|

  spec.name         = "Brickyard"
  spec.version      = "0.0.9"
  spec.summary      = "some custom and extension for iOS"
  spec.homepage     = "https://github.com/realLam/Brickyard.git"
  spec.license      = "MIT"
  spec.author       = { "reallam" => "bokor_lam@foxmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/realLam/Brickyard.git", :tag => spec.version }
  spec.source_files  = "Demo/Source", "Demo/Source/*"
  #依赖库
  #spec.dependency "SnapKit", "~> 5.0.0"
  #指定swift版本
  spec.swift_version = "5.0"
end
