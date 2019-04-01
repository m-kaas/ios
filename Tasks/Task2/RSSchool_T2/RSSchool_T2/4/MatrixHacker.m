#import "MatrixHacker.h"

@interface MatrixHacker ()
@property (nonatomic, copy) id<Character>(^savedBlock)(NSString *);
@end

@implementation MatrixHacker
- (void)injectCode:(id<Character> (^)(NSString *))theBlock {
    self.savedBlock = theBlock;
}

- (NSArray<id<Character>> *)runCodeWithData:(NSArray<NSString *> *)names {
    NSMutableArray *people = [NSMutableArray new];
    for (NSString *name in names) {
        [people addObject: self.savedBlock(name)];
    }
    NSArray<id<Character>> *result = [[people copy] autorelease];
    [people release];
    return result;
}

- (void)dealloc
{
    [_savedBlock release];
    _savedBlock = nil;
    [super dealloc];
}
@end
