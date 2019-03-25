#import "Sorted.h"

@implementation ResultObject
- (void)dealloc
{
    [_detail release];
    [super dealloc];
}
@end

@implementation Sorted

// Complete the sorted function below.
- (ResultObject*)sorted:(NSString*)string {
    NSArray *numbers = [string componentsSeparatedByString: @" "];
    int indexL = -1, indexR = -1;
    int indexMax = 0;
    int max = -1;
    BOOL swap = NO, reverse = NO;
    for (int i = 0; i < numbers.count; i++) {
        int number = [numbers[i] intValue];
        if (number >= max) {
            max = number;
            indexMax = i;
            continue;
        }
        // else if (number < max)
        if (indexL == -1) { // first "conflict", i.e. smaller number following bigger one
            indexL = indexMax;
        } else if (indexL != indexMax) { // if we have more than one "conflict", sorting using only one operation is impossible
            swap = NO;
            reverse = NO;
            break;
        }
        if (!swap && !reverse) { // swap and reverse weren't available before
            if (indexL != 0 && number < [numbers[indexL - 1] intValue]) {
                break;
            }
            if (i != indexL + 1 && number > [numbers[indexL + 1] intValue]) {
                continue;
            }
            // if clauses above check if numbers[left - 1] <= number <= numbers[left + 1]
            swap = YES;
            if (i == indexL + 1) {
                reverse = YES;
            }
            indexR = i;
            continue;
        }
        // else if (swap || reverse)
        if (number >= [numbers[indexR] intValue]) { // for example: 4 2 3
            swap = NO;
            reverse = NO;
            indexR = -1;
            continue; // not break; for example: 4 2 3 1
        }
        // else if (number < [numbers[indexR] intValue])
        if (i == indexR + 1) {
            if (i - indexL >= 3) { // we can swap [4 3 2], but [4 3 2 1] we can only reverse
                swap = NO;
            }
            indexR = i;
            continue;
        }
    }
    ResultObject *value = [[ResultObject new] autorelease];
    if (swap) {
        value.status = YES;
        value.detail = [NSString stringWithFormat: @"swap %d %d", indexL + 1, indexR + 1];
    } else if (reverse) {
        value.status = YES;
        value.detail = [NSString stringWithFormat: @"reverse %d %d", indexL + 1, indexR + 1];
    } else if (indexL == -1) { // no "conflicts"
        value.status = YES;
    } else {
        value.status = NO;
    }
    return value;
}

@end
