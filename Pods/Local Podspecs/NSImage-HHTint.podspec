Pod::Spec.new do |s|
  s.name         = 'NSImage-HHTint'
  s.version      = '0.0.1'
  s.license      = 'BSD'
  s.platform     = :osx
  s.summary      = 'Tints grayscale images using CoreImage'
  s.homepage     = 'https://github.com/gloubibou/NSImage-HHTint'
  s.author       = { 'Pierre Bernard' => 'example@example.com' }
  s.source       = { :git => 'https://github.com/gloubibou/NSImage-HHTint.git', :commit => 'HEAD' }
  s.source_files = 'NSImage+HHTint.{h,m}'
  s.requires_arc = true
end
