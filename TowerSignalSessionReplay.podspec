Pod::Spec.new do |s|
  s.name         = "TowerSignalSessionReplay"
  s.version      = "4.0.0"
  s.summary      = "Official TowerSignal Session Replay SDK for iOS."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'

  s.source = { :git => "https://github.com/TowerSignal/towersignal-sdk-ios.git", :tag => s.version.to_s }

  s.source_files = ["TowerSignalSessionReplay/Sources/**/*.swift"]
  s.dependency 'TowerSignalInternal', s.version.to_s
end
