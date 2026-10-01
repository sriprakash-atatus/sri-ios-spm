Pod::Spec.new do |s|
  s.name         = "TestUtilities"
  s.version      = "4.0.0"
  s.summary      = "TowerSignal Testing Utilities. This module is for internal testing and should not be published."

  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = { "TowerSignal" => "info@towersignal.com" }

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'

  s.source = { :git => "https://github.com/sriprakash-atatus/sri-ios-spm.git", :tag => "v#{s.version}" }

  s.pod_target_xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS'=>'YES'
  }

  s.framework = 'XCTest'

  s.source_files = [
    "TestUtilities/Sources/**/*.swift"
  ]

  s.dependency 'TowerSignalCore'
  s.dependency 'TowerSignalInternal'
  s.dependency 'TowerSignalLogs'
  s.dependency 'TowerSignalRUM'
  s.dependency 'TowerSignalSessionReplay'
  s.dependency 'TowerSignalTrace'
  s.dependency 'TowerSignalCrashReporting'
  s.dependency 'TowerSignalWebViewTracking'

end