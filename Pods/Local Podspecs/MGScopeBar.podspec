Pod::Spec.new do |s|
  s.name         = 'MGScopeBar'
  s.version      = '0.0.1'
  s.license      = 'BSD'
  s.platform     = :osx
  s.summary      = 'MGScopeBar is a control which provides a "scope bar" or "filter bar", much like that found in iTunes, the Finder (in the Find/Spotlight window), and Mail.'
  s.homepage     = 'http://mattgemmell.com/2008/10/28/mgscopebar/'
  s.author       = { 'Matt Gemmell' => 'matt@mattgemmell.com' }
  s.source       = { :svn => 'http://svn.cocoasourcecode.com/MGScopeBar' }
  s.source_files = 'MG*.{h,m}'
  s.requires_arc = false
end
