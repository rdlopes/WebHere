Pod::Spec.new do |s|

  s.name          = "WebHere"
  s.version       = "0.1.3"
  s.summary       = "HTML scraping for Objective-C."
  s.homepage      = "https://github.com/rdlopes/WebHere"
  s.license       = { :type => 'MIT', 
                      :file => 'LICENSE' }
  s.author        = { "Rui Lopes" => "rui.d.lopes@icloud.com" }
  s.source        = { :git => "https://github.com/rdlopes/WebHere.git" }
  
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files  = 'WebHere/*.{h,m}'
  s.requires_arc  = true
  s.documentation = { :html => 'https://github.com/rdlopes/WebHere/',
                      :appledoc => [
                        '--project-name',      s.name.to_s,
                        '--project-company',   "Rui Lopes",
                        '--docset-copyright',  "Rui Lopes",
                        '--ignore',            '.m',
                        '--index-desc',        'README.md',
                        '--no-keep-undocumented-objects',
                        '--no-keep-undocumented-members',
                      ]}  

  s.dependency 'AFNetworking', '~> 1.1.0'
  s.dependency 'CocoaLumberjack'

  s.libraries = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  
end
