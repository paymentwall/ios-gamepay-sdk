Pod::Spec.new do |s|
  s.name                = 'GamePaySDK'
  s.version             = '1.0.0'
  s.homepage            = 'https://terminal3.com'
  s.documentation_url   = 'https://docs.terminal3.com/'
  s.license             = { :type => 'Commercial' }
  s.author              = { 'Terminal3' => 'support@terminal3.com' }
  s.summary             = 'Introducing GamePaySDK by Terminal3'

  s.platform            = :ios, '13.0'
  s.source              = { :path => './GamePaySDK' }

  s.xcconfig            = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/GamePaySDK/**"' }
  s.requires_arc        = true
  s.swift_version       = '5.0'
  s.module_name         = 'GamePaySDK'

  s.preserve_paths      = 'GamePaySDK.xcframework'
  s.vendored_frameworks = 'GamePaySDK.xcframework'
end