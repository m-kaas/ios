#import "Encryption.h"

@implementation Encryption

// Complete the encryption function below.
- (NSString *)encryption:(NSString *)string {
    int cols = ceil(sqrt(string.length));
    NSMutableString *encryptedString = [NSMutableString new];
    for (int i = 0; i < cols; i++) {
        for (int j = 0; i + j * cols < string.length; j++) {
            [encryptedString appendString:[string substringWithRange: NSMakeRange(i + j * cols, 1)]];
        }
        [encryptedString appendString: @" "];
    }
    [encryptedString deleteCharactersInRange: NSMakeRange([encryptedString length] - 1, 1)];
    NSString *result = [[encryptedString copy] autorelease];
    [encryptedString release];
    return result;
}

@end
