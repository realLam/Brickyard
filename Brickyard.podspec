Pod::Spec.new do |spec|

  spec.name         = "Brickyard"
  spec.version      = "0.0.1"
  spec.summary      = "some custom or extension for iOS"
  spec.homepage     = "https://github.com/realLam/Brickyard"
  spec.license      = "MIT"
  spec.author       = { "reallam" => "bokor_lam@foxmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/realLam/Brickyard.git", :tag => spec.version }
  spec.source_files  = "Classes/*"
  #依赖库
  spec.dependency "SnapKit", "~> 5.0.0"
  #指定swift版本
  spec.swift_version = "5.0"
end