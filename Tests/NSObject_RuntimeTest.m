// NSObject_RuntimeTest.m
//
// Copyright (c) 2014 Rui Lopes
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

#import "WebHereTests.h"

@interface NSObject_RuntimeTest : WebHereTests

@end

@implementation NSObject_RuntimeTest

- (void)testPropertiesNamesFromCurrentClassAreExtracted {
    NSSet *propertiesNames = [WHNSObjectSubClassed propertiesNames];

    expect(propertiesNames).to.contain(@"subProperty");
    expect(propertiesNames).notTo.contain(@"synthesizedProperty");
    expect(propertiesNames).notTo.contain(@"publicProperty");
}

- (void)testPropertiesNamesFromHierarchyAreExtracted {
    NSSet *allPropertiesNames = [WHNSObjectSubClassed allPropertiesNames];

    expect(allPropertiesNames).to.contain(@"synthesizedProperty");
    expect(allPropertiesNames).to.contain(@"publicProperty");
    expect(allPropertiesNames).to.contain(@"subProperty");
}

- (void)testSubclassesAreExtracted {
    expect([WHNSObject subclassesNames]).to.contain(NSStringFromClass([WHNSObjectSubClassed class]));
}

@end
