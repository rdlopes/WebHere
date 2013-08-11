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

  s.prefix_header_contents = <<-EOS
// COMMON
#ifdef __OBJC__

    #import <Foundation/Foundation.h>
    #import <SystemConfiguration/SystemConfiguration.h>
    #import <Security/Security.h>

    #define _AFNETWORKING_PIN_SSL_CERTIFICATES_

    // IOS
    #if __IPHONE_OS_VERSION_MIN_REQUIRED

        #import <UIKit/UIKit.h>
        #import <MobileCoreServices/MobileCoreServices.h>

        #define NSInteger NSUInteger

    // OSX
    #elif __MAC_OS_X_VERSION_MIN_REQUIRED

        #import <Cocoa/Cocoa.h>
        #import <CoreServices/CoreServices.h>

    #endif
#endif

// Log levels
#import <CocoaLumberjack/DDLog.h>
#ifdef DEBUG
    static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    static const int ddLogLevel = LOG_LEVEL_WARN;
#endif
EOS

end
