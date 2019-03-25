#import "SummArray.h"

@implementation SummArray

// Complete the summArray function below.
- (NSNumber *)summArray:(NSArray *)array {
    [array retain];
    int sum = 0;
    for (id obj in array) {
        sum += [obj intValue];
    }
    [array release];
    return @(sum);
}

@end
