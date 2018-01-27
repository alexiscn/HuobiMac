Pod::Spec.new do |s|
  s.name         = 'HuobiSwift'
  s.version      = '0.0.1'
  s.license = 'MIT'
  s.requires_arc = true
  s.source = {:path => 'DevelopmentPods/HuobiSwift'}

  s.summary = 'HuobiSwift'
  s.homepage = 'HuobiSwift'
  s.author       = { 'xushuifeng' => 'https://github.com/alexiscn' }
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.source_files = '*.swift', '**/*.swift'
  
  s.dependency 'Starscream'
  s.dependency 'GzipSwift'
  s.dependency 'GenericNetworking'

end
