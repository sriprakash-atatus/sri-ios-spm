Pod::Spec.new do |s|
  s.name         = "TowerSignalCrashReporting"
  s.version      = "4.0.0"
  s.summary      = "Official TowerSignal Crash Reporting SDK for iOS."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => 'https://github.com/sriprakash-atatus/sri-ios-spm.git', :tag => s.version.to_s }

  s.source_files = "TowerSignalCrashReporting/Sources/**/*.swift"
  s.dependency 'TowerSignalInternal', s.version.to_s
  s.dependency 'KSCrash/Recording', '2.5.1'
  s.dependency 'KSCrash/Filters', '2.5.1'

  s.resource_bundle = {
    "TowerSignalCrashReporting" => "TowerSignalCrashReporting/Resources/PrivacyInfo.xcprivacy"
  }
end
