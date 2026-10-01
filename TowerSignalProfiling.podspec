Pod::Spec.new do |s|
  s.name         = "TowerSignalProfiling"
  s.version      = "4.0.0"
  s.summary      = "Official TowerSignal Profiling module of the Swift SDK."
  
  s.homepage     = "https://www.towersignal.com"

  s.license            = { :type => "Apache", :file => 'LICENSE' }
  s.authors            = "TowerSignal, Inc."

  s.swift_version = '5.9'
  s.ios.deployment_target = '15.0'
  s.tvos.deployment_target = '15.0'
  s.visionos.deployment_target = '1.0'

  s.source = { :git => "https://github.com/sriprakash-atatus/sri-ios-spm.git", :tag => s.version.to_s }
  
  s.source_files = ["TowerSignalProfiling/Sources/**/*.swift",
                    "TowerSignalProfiling/Mach/**/*.{h,c,cpp}"]
  
  s.private_header_files = ["TowerSignalProfiling/Mach/**/*.h"]

  s.preserve_paths = "TowerSignalProfiling/Mach/include/module.modulemap"

  s.dependency 'TowerSignalInternal', s.version.to_s

  # Configure C++ compilation
  s.pod_target_xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/TowerSignalProfiling/Mach/include'
  }

end
