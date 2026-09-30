Pod::Spec.new do |s|
  s.name         = "TowerSignalCore"
  s.version      = "3.15.0"
  s.summary      = "Official TowerSignal Swift SDK for iOS."
  
  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '5.9'
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '7.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => "https://github.com/TowerSignal/towersignal-sdk-ios.git", :tag => s.version.to_s }
  
  s.source_files = ["TowerSignalCore/Sources/**/*.swift",
                    "TowerSignalCore/Private/**/*.{h,m}"]

  s.resource_bundle = {
    "TowerSignalCore" => "TowerSignalCore/Resources/PrivacyInfo.xcprivacy"
  }

  s.dependency 'TowerSignalInternal', s.version.to_s

end
