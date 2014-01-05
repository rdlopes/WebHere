Pod::Spec.new do |s|

  s.name         = "WebHere"
  s.version      = "0.2.0"
  s.summary      = "Web scraping for Objective-C."
  s.description  = <<-DESC
	WebHere is an Objective-C framework for web scraping, packaged for iOS 7+ and OSX 10.8+ platforms.
	Briefly put, web scraping is parsing of a website and extraction of data from the HTML pages contained in it.
                   DESC
  s.homepage     = "https://github.com/rdlopes/WebHere"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Rui Lopes" => "rui.d.lopes@me.com" }
  s.source       = { :git => "https://github.com/rdlopes/WebHere.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  
  subspec "HTMLDocument" do |hs|
  	hs.author = { "Stefan Klieme" => "stefan@klieme.com" }
  	hs.source = { :git => "https://github.com/stklieme/HTMLDocument", :branch => "head" }
  	hs.source_files = '*.{h,m}'
  end
  
  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'CocoaLumberjack'
  
  s.libraries = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

end
