#import "RomanTranslator.h"

@implementation RomanTranslator
- (NSString *)romanFromArabic:(NSString *)arabicString {
    int arabicNumber = arabicString.intValue;
    NSDictionary *letters = @{@1000: @"M", @900: @"CM", @500: @"D", @400: @"CD", @100: @"C", @90: @"XC", @50: @"L", @40: @"XL", @10: @"X", @9: @"IX", @5: @"V", @4: @"IV", @1: @"I"};
    NSMutableString *romanString = [@"" mutableCopy];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray *sortedKeys = [letters.allKeys sortedArrayUsingDescriptors:@[sd]];
    for (int i = 0; i < sortedKeys.count;) {
        NSNumber *key = (NSNumber *)sortedKeys[i];
        if (arabicNumber >= key.intValue) {
            [romanString appendString:letters[key]];
            arabicNumber -= key.intValue;
        } else {
            i++;
        }
    }
    NSString *result = [[romanString copy] autorelease];
    [romanString release];
    [sd release];
    return result;
}

- (NSString *)arabicFromRoman:(NSString *)romanString {
    [romanString retain];
    NSDictionary *numbers = @{@"M": @1000, @"D": @500, @"C": @100, @"L": @50, @"X": @10, @"V": @5, @"I": @1};
    int arabicNumber = 0;
    for (int i = 0; i < romanString.length; i++) {
        NSString *letter = [NSString stringWithFormat: @"%C", [romanString characterAtIndex: i]];
        NSNumber *number = (NSNumber *)numbers[letter];
        int d = number.intValue;
        if (i + 1 < romanString.length) {
            NSString *nextLetter = [NSString stringWithFormat: @"%C", [romanString characterAtIndex: i + 1]];
            NSNumber *nextNumber = (NSNumber *)numbers[nextLetter];
            if (number.intValue < nextNumber.intValue) {
                d = -d;
            }
        }
        arabicNumber += d;
    }
    [romanString release];
    return [[NSString stringWithFormat:@"%d", arabicNumber] autorelease];
}
@end
