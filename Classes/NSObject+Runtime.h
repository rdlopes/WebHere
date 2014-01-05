// NSObject+Runtime.h
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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
   Utilities around runtime introspection for classes.

   Found easier to use than the <objc/runtime.h> methods which require fiddling with C data structures.
   SiteMap uses these methods to query properties from SMWebRequest objects or unknown objects types like the ones conforming to protocol SMWebPage.
 */
@interface NSObject (RunTime)

/**----------------------------------------------------
 @name List properties
 -----------------------------------------------------*/

/** Lists all properties names declared in its interface.

 In this version, properties declared in super classes will be ignored. Only those listed in the header file will be listed here.

 @see [StackOverFlow](http://stackoverflow.com/questions/3001441/get-string-value-of-class-propery-names-in-objective-c)
 */
+ (NSSet *)propertiesNames;

/** Lists all properties names declared by this class.

 In this version, properties declared by super classes will also be listed by this method.

 @see [StackOverFlow](http://stackoverflow.com/questions/3001441/get-string-value-of-class-propery-names-in-objective-c)
 */
+ (NSSet *)allPropertiesNames;

/**----------------------------------------------------
 @name List subclasses
 -----------------------------------------------------*/

/** Lists the names of the classes that subclass this class.

 @see [Cocoa With Love](http://cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html)
 */
+ (NSSet *)subclassesNames;

/**----------------------------------------------------
 @name Describe an instance
 -----------------------------------------------------*/

/** Prints legacy description plus the description of the properties.

 This method uses propertiesNames so the description for the properties from super classes are not printed.
 */
- (NSString *)fullDescription;

@end
