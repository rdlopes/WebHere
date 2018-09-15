# WebHere

[![CI Status](http://img.shields.io/travis/rdlopes/WebHere.svg?style=flat)](https://travis-ci.org/rdlopes/WebHere)
[![Version](https://img.shields.io/cocoapods/v/WebHere.svg?style=flat)](http://cocoadocs.org/docsets/WebHere)
[![License](https://img.shields.io/cocoapods/l/WebHere.svg?style=flat)](http://cocoadocs.org/docsets/WebHere)
[![Platform](https://img.shields.io/cocoapods/p/WebHere.svg?style=flat)](http://cocoadocs.org/docsets/WebHere)

WebHere is an Objective-C framework for [web scraping](http://en.wikipedia.org/wiki/Web_scraping), packaged for iOS 8+ and OSX 10.10+ platforms.

Briefly put, web scraping is parsing of a website and extraction of data from the HTML pages contained in it.

This work has been inspired by [RestKit](https://github.com/RestKit/RestKit), 
but aimed at HTML data and working in a simpler form (no mapping upfront, model classes declare their own building strategy); 
it is mostly relying on:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking) to perform all network operations.
* [GDataXML-HTML](https://github.com/graetzer/GDataXML-HTML) to extract data using XPath.

Those two projects really deserve attention on their own, make sure to visit their page and understand their APIs, 
as WebHere will mostly provide a unified facade to their APIs.

## Features

* Downloads HTML pages and extracts data into user-defined classes.
* Allows the user to use XPath to query the HTML document.
* Pre-defined methods to extract links and forms.
* Tested.

## Limitations

* At this moment only GET and POST REST methods have been tested.
* Please pay attention to the legal issues when peforming web scraping.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Having a look at the test cases provided should give you an overview of the API.

Example folder contains an iOS app that maps HTML to query Google.

## Requirements

Dependencies are automatically managed by Cocoapod. 
In case you have to add WebHere to your source tree and use it outside Cocoapod, 
you must add the following projects along with WebHere:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking) for network operations
* [GDataXML-HTML](https://github.com/graetzer/GDataXML-HTML) for XPath extraction

## Installation

WebHere is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "WebHere"

Alternatively, you can add these sources as a git submodule.

## Author

Rui Lopes, rui.d.lopes@me.com

## License

WebHere is available under the MIT license. See the LICENSE file for more info.

## Testing

Project has been covered by unit tests using:

* [Specta/Expecta](https://github.com/specta/expecta) for the generic testing framework.
* [Nocilla](https://github.com/luisobo/Nocilla) for stubbing network requests.

Please notice that all tests are performed locally, meaning that no actual network access is needed, all requests being stubed by Nocilla.

## Contributing

1. Fork it
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create new Pull Request

