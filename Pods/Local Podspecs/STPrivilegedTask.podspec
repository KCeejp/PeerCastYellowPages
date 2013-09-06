Pod::Spec.new do |s|
  s.name         = 'STPrivilegedTask'
  s.version      = '0.0.1'
  s.license      = 'BSD'
  s.platform     = :osx
  s.summary      = 'An NSTask-like wrapper around AuthorizationExecuteWithPrivileges() to run shell commands with root privileges in Objective-C / Cocoa on Mac OS X.'
  s.homepage     = 'https://github.com/sveinbjornt/STPrivilegedTask'
  s.author       = { 'Sveinbjorn Thordarson' => 'sveinbjornt@gmail.com' }
  s.source       = { :git => 'https://github.com/sveinbjornt/STPrivilegedTask.git', :commit => 'HEAD' }
  s.source_files = 'STPrivilegedTask.{h,m}'
  s.requires_arc = false
end
