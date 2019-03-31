#import "KidnapperNote.h"

@implementation KidnapperNote
- (BOOL)checkMagazine:(NSString *)magaine note:(NSString *)note {
    NSCountedSet *magazineWords = [[NSCountedSet alloc] initWithArray: [[magaine lowercaseString] componentsSeparatedByString:@" "]];
    NSCountedSet *noteWords = [[NSCountedSet alloc] initWithArray: [[note lowercaseString] componentsSeparatedByString:@" "]];
    BOOL result = [noteWords isSubsetOfSet:magazineWords];
    [magazineWords release];
    [noteWords release];
    return result;
}
@end
