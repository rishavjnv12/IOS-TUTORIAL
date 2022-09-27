Pod::Spec.new do |spec|
  spec.name         = "NVDBManager"
  spec.version      = "1.0.0"
  spec.summary      = "A DB manager"

  spec.description  = "uses url request"

  spec.homepage     = "http://EXAMPLE/NaviThirdPartyCommons"

  spec.author             = { "Rishav Kumar" => "rishav.kumar@navi.com" }
 
  spec.ios.deployment_target = "15.5"

  spec.source       = { :git => "http://www.github.com/NaviThirdPartyCommons.git", :tag => "#{spec.version}" }
  
  spec.static_framework = false
  
  spec.ios.vendored_frameworks = "Frameworks/HyperSnapSDK.xcframework"
  spec.ios.resource = "Frameworks/HVResources.bundle"

  spec.source_files  = "NVDBManager", "NVDBManager/**/*.{swift,xib}"
  spec.exclude_files = "Classes/Exclude"
end
