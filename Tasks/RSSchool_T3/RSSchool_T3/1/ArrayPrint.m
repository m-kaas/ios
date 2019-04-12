#import "ArrayPrint.h"

@implementation NSArray (RSSchool_Extension_Name)

- (NSString *)print {
    NSMutableArray *elements = [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        id elem = [self objectAtIndex: i];
        if ([elem isKindOfClass: [NSArray class]]) {
            [elements addObject: [elem print]];
        } else if ([elem isKindOfClass: [NSString class]]) {
            [elements addObject: [NSString stringWithFormat:@"\"%@\"", elem]];
        } else if ([elem isKindOfClass: [NSNumber class]]) {
            [elements addObject: [elem stringValue]];
        } else if ([elem isKindOfClass: [NSNull class]]) {
            [elements addObject: @"null"];
        } else {
            [elements addObject: @"unsupported"];
        }
    }
    NSString *result = [NSString stringWithFormat:@"[%@]", [elements componentsJoinedByString:@","]];
    [elements release];
    return result;
}

@end
