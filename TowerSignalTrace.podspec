Pod::Spec.new do |s|
  s.name         = "TowerSignalTrace"
  s.version      = "4.0.0"
  s.summary      = "TowerSignal Trace Module."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '6.0'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => "https://github.com/TowerSignal/towersignal-sdk-ios.git", :tag => s.version.to_s }

  s.source_files = ["TowerSignalTrace/Sources/**/*.swift"]

  s.dependency 'TowerSignalInternal', s.version.to_s
  s.dependency 'OpenTelemetry-Swift-Api', '~> 2.5.0'
end
