#import <XCTest/XCTest.h>
#import "MatrixHacker.h"

@interface MatrixHackerTests : XCTestCase
@property (nonatomic, strong) MatrixHacker *hacker;
@property (nonatomic, retain) NSArray *people;
@end

@interface Char : NSObject <Character>
@property (nonatomic, getter=isClone) BOOL clone;
@property (nonatomic, copy) NSString *name;
@end
@implementation Char
+ (instancetype)createWithName:(NSString *)name isClone:(BOOL)clone {
    Char *person = [Char new];
    person.name = name;
    person.clone = clone;
    return [person autorelease];
}
- (void)dealloc
{
    [_name release];
    [super dealloc];
}
@end

@implementation MatrixHackerTests

- (void)setUp {
  self.hacker = [MatrixHacker new];
  self.people = @[@"Delivery Guy", @"Neo", @"Policeman", @"Agent John", @"Agent Black", @"Bartender"];
}

- (void)test1 {
  __block NSInteger counter = 0;
  [self.hacker injectCode:^id<Character>(NSString *name) {
      counter += 1;
      if ([name isEqualToString: @"Neo"]) {
          return [Char createWithName:@"Neo" isClone:NO];
      } else {
          return [Char createWithName:@"Agent Smith" isClone:YES];
      }
  }];
  [self.hacker runCodeWithData:self.people];
  XCTAssertTrue(self.people.count == counter);
}


@end
