Pod::Spec.new do |s|
  s.name         = "TowerSignalFlags"
  s.version      = "4.0.0"
  s.summary      = "Official TowerSignal Feature Flags module of the Swift SDK."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = "TowerSignal, Inc."

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => "https://github.com/sriprakash-atatus/sri-ios-spm.git", :tag => "v#{s.version}" }

  s.source_files = "TowerSignalFlags/Sources/**/*.swift"

  s.dependency 'TowerSignalInternal', s.version.to_s

end
