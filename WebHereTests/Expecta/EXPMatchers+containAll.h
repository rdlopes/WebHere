#import "Expecta.h"

EXPMatcherInterface(_containAll, (id expected));
EXPMatcherInterface(containAll, (id expected)); // to aid code completion
#define containAll(expected) _containAll(EXPObjectify((expected)))
