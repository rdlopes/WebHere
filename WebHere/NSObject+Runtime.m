//
// NSObject+Runtime.m
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

#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

#pragma mark - Properties

+ (NSSet *)propertiesNames {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableSet *propertiesSet = [NSMutableSet setWithCapacity:count];
    if (![NSStringFromClass(self) isEqualToString:NSStringFromClass([NSObject class])]) {
        for (int i = 0; i < count; i++) {
            NSString *name = @(property_getName(properties[i]));
            [propertiesSet addObject:name];
        }
        free(properties);
    }
    return propertiesSet;
}

+ (NSSet *)allPropertiesNames {
    NSMutableSet *propertiesSet = [[self propertiesNames] mutableCopy];
    [propertiesSet unionSet:[[self superclass] propertiesNames]];
    return propertiesSet;
}

#pragma mark - Class Hierarchies

+ (NSSet *)subclassesNames {
    int count;
    Class *classes = NULL;

    classes = NULL;
    count = objc_getClassList(NULL, 0);

    NSMutableSet *classesSet = [NSMutableSet setWithCapacity:(NSUInteger) count];
    if (count > 0) {
        classes = (__unsafe_unretained Class *) malloc(sizeof(Class) * count);
        count = objc_getClassList(classes, count);

        for (int i = 0; i < count; i++) {
            Class superClass = classes[i];
            do {
                superClass = class_getSuperclass(superClass);
            } while (superClass && superClass != self);

            if (superClass == nil) {
                continue;
            }

            const char *className = class_getName(classes[i]);
            [classesSet addObject:@(className)];
        }
        free(classes);
    }
    return classesSet;
}

#pragma mark - Utils

- (NSString *)fullDescription {
    NSString *fullDescription = [NSString stringWithFormat:@"\n %@", [self description]];
    for (NSString *propertyName in [[self class] allPropertiesNames]) {
        fullDescription = [fullDescription stringByAppendingFormat:@"\n%@=%@", propertyName, [self valueForKey:propertyName]];
    }
    return fullDescription;
}

@end
