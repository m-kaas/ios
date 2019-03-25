#import "Diagonal.h"

@implementation Diagonal

// Complete the diagonalDifference function below.
- (NSNumber *) diagonalDifference:(NSArray *)array {
    int d1sum = 0, d2sum = 0;
    int i = 0;
    for (NSString *str in array) {
        NSArray *row = [str componentsSeparatedByString: @" "];
        d1sum += [row[i] intValue];
        d2sum += [row[array.count - 1 - i] intValue];
        i++;
    }
    return @(abs(d1sum - d2sum));
}

@end
