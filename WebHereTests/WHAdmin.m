// WHAdmin.m
// 
// Copyright (c) 2013 Rui D Lopes
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WHAdmin.h"

@implementation WHAdmin
@synthesize URL = _URL;

- (BOOL)matches:(HTMLDocument *)webPage fromRequest:(WHRequest *)request
{
    // should have rights
    return [webPage.body nodeWithAttribute:@"id" valueMatches:@"rights"].stringValue.length;
}

- (void)buildWithHTMLPage:(HTMLDocument *)webPage fromRequest:(WHRequest *)request error:(NSError *__autoreleasing *)error
{
    self.nickname = webPage.title;
    
    NSString *rights = [webPage.body nodeWithAttribute:@"id" valueMatches:@"rights"].stringValue;
    if ([rights isEqualToString:@"ReadWrite"]) {
        self.rights = WHAdminRightsReadWrite;
    } else if ([rights isEqualToString:@"WriteOnly"]) {
        self.rights = WHAdminRightsWriteOnly;
    } else {
        self.rights = WHAdminRightsUnknown;
    }
}

@end
