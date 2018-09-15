Pod::Spec.new do |s|
s.name             = 'WebHere'
s.version          = '0.4.0'
s.summary          = 'HTML scraping for Objective-C.'
s.description      = <<-DESC
WebHere is an Objective-C framework for web scraping,
packaged for iOS 8+ and OSX 10.10+ platforms.

Briefly put, web scraping is parsing of a website and extraction
of data from the HTML pages contained in it.
DESC
s.homepage         = 'https://github.com/rdlopes/WebHere'
s.license          = 'MIT'
s.author           = { 'Rui Lopes' => 'rui.d.lopes@me.com' }
s.source           = { :git => "https://github.com/rdlopes/WebHere.git", :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'
s.requires_arc = true

s.source_files = 'WebHere/Classes/**/*'

s.dependency 'AFNetworking'
s.dependency 'GDataXML-HTML'

end
