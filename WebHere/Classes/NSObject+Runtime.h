//
// NSObject+Runtime.h
// WebHere
//
// Created by Rui Lopes on 06/10/2014.
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
//

#ifndef NSObject_Runtime_h
#define NSObject_Runtime_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 `NSObject_Runtime` is a set of extensions on [NSObject] class to allow querying objects for their properties and subclasses.
 This allows the [WHWebsite] to populate properties of objects referred as targets.

 @warning This class is only for internal use, using it outside WebHere is done at the developer's costs.
 */
@interface NSObject (RunTime)

///-------------------------------
/// @name Properties
///-------------------------------

/**
 Queries an object for its declared properties.
 Notice that properties declared by super classes are ignored.
 See allPropertiesNames for a full query of the class hierarchy.

 @return a set of strings listing the properties declared by this object.
 */
+ (NSSet *)propertiesNames;

/**
 Queries an object for all its properties.
 Notice that properties declared bby super classes are included in the returned set.
 See propertiesNames for querying properties declared only by the class of this object.

 @return a [NSSet] of strings listing all properties contained in this object.
 */
+ (NSSet *)allPropertiesNames;

///-------------------------------
/// @name Class hierarchy
///-------------------------------

/**
 Queries an object's class for all declared subclasses.

 @return a [NSSet] of strings listing all subclasses existing for that object's class.
 */
+ (NSSet *)subclassesNames;

///-------------------------------
/// @name Utils
///-------------------------------

/**
 Convenient method to debug all object's properties and their values.

 @return an [NSString] serving as a debug string for the object.
 */
- (NSString *)fullDescription;

@end

#endif