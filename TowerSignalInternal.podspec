Pod::Spec.new do |s|
  s.name         = "TowerSignalInternal"
  s.version      = "4.0.0"
  s.summary      = "TowerSignal Internal Package. This module is not for public use."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => "https://github.com/sriprakash-atatus/sri-ios-spm.git", :tag => "v#{s.version}" }

  s.source_files = ["TowerSignalInternal/Sources/**/*.swift"]

end
