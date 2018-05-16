  
pod::Spec.new do |s|
  s.name         = 'LLPhotosBrowser'
  s.version      = '1.1'
  s.summary      = 'A simple iOS photo browser'
  s.homepage     = 'https://github.com/lianleven/LLPhotosBrowser'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors       = { 'lianleven' => 'lianleven@163.com' }
  s.source       = { :git => 'https://github.com/lianleven/LLPhotosBrowser.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.platform     = :ios, '7.0'
  s.source_files = 'LLPhotosBrowser/LLPhotosBrowser/*.{h,m}'

  s.requires_arc = true
end
