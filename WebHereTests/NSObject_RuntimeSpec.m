//
// NSObject_RuntimeSpec.m
// WebHere
//
// Created by Rui Lopes on 06/10/2014.
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
//

#import "WebHereTests.h"

SpecBegin(NSObject_Runtime)

describe(@"NSObject_Runtime", ^{

    it(@"should extract properties names", ^{
        expect([WHNSObject propertiesNames]).to.containAll((@[@"synthesizedProperty", @"publicProperty"]));
        expect([WHNSObjectSubclassed propertiesNames]).to.contain(@"subProperty");
    });

    it(@"should extract properties names from superclass", ^{
        expect([WHNSObjectSubclassed allPropertiesNames]).to.containAll((@[@"synthesizedProperty", @"publicProperty", @"subProperty"]));
    });

    it(@"should extract subclasses names", ^{
        expect([WHNSObject subclassesNames]).to.contain(NSStringFromClass([WHNSObjectSubclassed class]));
    });

});

SpecEnd
