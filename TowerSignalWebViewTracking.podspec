Pod::Spec.new do |s|
  s.name         = "TowerSignalWebViewTracking"
  s.version      = "4.0.0"
  s.summary      = "TowerSignal WebView Tracking Module."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => "https://github.com/sriprakash-atatus/sri-ios-spm.git", :tag => s.version.to_s }

  s.source_files = ["TowerSignalWebViewTracking/Sources/**/*.swift"]

  s.dependency 'TowerSignalInternal', s.version.to_s

end
