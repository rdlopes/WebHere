# WebHere [_Work In Progress_]

WebHere is an Objective-C framework for [web scraping](http://en.wikipedia.org/wiki/Web_scraping), packaged for iOS 5+ and OSX 10.7+ platforms.

Briefly put, web scraping is parsing of a website and extraction of data from the HTML pages contained in it.

This work has been inspired by [RestKit](https://github.com/RestKit/RestKit), but aimed at HTML data and working in a simpler form (no mapping upfront, model classes declare their own building strategy); it is mostly relying on:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking) to perform all network operations.
* [HTMLDocument](https://github.com/stklieme/HTMLDocument) to extract data using XPath.

Those two projects really deserve attention on their own, make sure to visit their page and understand their APIs, as WebHere will mostly provide a unified facade to their APIs.

## Features

* Downloads HTML pages and extracts data into user-defined classes.
* Allows the user to use XPath to query the HTML document.
* Pre-defined methods to extract links and forms.
* Tested.

## Limitations

* At this moment only GET and POST REST methods have been tested.
* Please pay attention to the legal issues when peforming web scraping.
* Authorization credentials (username/password and token based) have not been tested.

## Installation

* Preferred way is by using [CocoaPod](http://cocoapods.org/) (_Work In Progress_).
* You should be able to add WebHere to you source tree. If you are using git, consider using a `git submodule`

## Dependencies

Dependencies are automatically managed by Cocoapod. In case you have to add WebHere to your source tree and use it outside Cocoapod, you must add the following projects along with WebHere:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking) for network operations
* [OCLogTemplate](https://github.com/jasperblues/OCLogTemplate) for logging purpose

## Usage

TBD - Having a look at the test cases provided should give you an overview of the API.

## Testing

Project has been covered by unit tests using:

* [Kiwi](https://github.com/allending/Kiwi) for the generic testing framework.
* [Nocilla](https://github.com/luisobo/Nocilla) for stubbing network requests.

Please notice that all tests are performed locally, meaning that no actual network access is needed, all requests being stubed by Nocilla.


## Contributing

1. Fork it
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create new Pull Request