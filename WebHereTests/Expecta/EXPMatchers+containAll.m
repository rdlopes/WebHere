#import "EXPMatchers+containAll.h"

EXPMatcherImplementationBegin(_containAll, (id expected)) {
  BOOL actualIsCompatible = [actual isKindOfClass:[NSString class]] || [actual conformsToProtocol:@protocol(NSFastEnumeration)];
  BOOL expectedIsCompatible = [expected isKindOfClass:[NSString class]] || [expected conformsToProtocol:@protocol(NSFastEnumeration)];
  BOOL expectedIsNil = (expected == nil);

  prerequisite(^BOOL{
    return actualIsCompatible && expectedIsCompatible && !expectedIsNil;
  });

  match(^BOOL{
    if(actualIsCompatible && expectedIsCompatible) {
      if([actual isKindOfClass:[NSString class]]) {
        return [(NSString *)actual rangeOfString:[expected description]].location != NSNotFound;
      } else {
          for (id object in expected) {
              if (![actual containsObject:object]) return NO;
          }
          return YES;
      }
    }
    return NO;
  });

  failureMessageForTo(^NSString *{
    if(!actualIsCompatible) return [NSString stringWithFormat:@"%@ is not an instance of NSString or NSFastEnumeration", EXPDescribeObject(actual)];
    if(!expectedIsCompatible) return [NSString stringWithFormat:@"%@ is not an instance of NSString or NSFastEnumeration", EXPDescribeObject(expected)];
    if(expectedIsNil) return @"the expected value is nil/null";
    return [NSString stringWithFormat:@"expected %@ to contain %@", EXPDescribeObject(actual), EXPDescribeObject(expected)];
  });

  failureMessageForNotTo(^NSString *{
    if(!actualIsCompatible) return [NSString stringWithFormat:@"%@ is not an instance of NSString or NSFastEnumeration", EXPDescribeObject(actual)];
    if(!expectedIsCompatible) return [NSString stringWithFormat:@"%@ is not an instance of NSString or NSFastEnumeration", EXPDescribeObject(expected)];
    if(expectedIsNil) return @"the expected value is nil/null";
    return [NSString stringWithFormat:@"expected %@ not to contain %@", EXPDescribeObject(actual), EXPDescribeObject(expected)];
  });
}
EXPMatcherImplementationEnd
