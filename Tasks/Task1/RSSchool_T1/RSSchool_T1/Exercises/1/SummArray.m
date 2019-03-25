#import "SummArray.h"

@implementation SummArray

// Complete the summArray function below.
- (NSNumber *)summArray:(NSArray *)array {
    int sum = 0;
    for (id obj in array) {
        sum += [obj intValue];
    }
    return @(sum);
}

@end
