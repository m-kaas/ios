#import "TinyURL.h"

@interface TinyURL ()

@property (nonatomic, retain) NSMutableDictionary *urlDB;

@end

@implementation TinyURL

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urlDB = [NSMutableDictionary new];
    }
    return self;
}

- (NSURL *)encode:(NSURL *)originalURL {
    if ([self.urlDB.allKeys containsObject: [originalURL absoluteString]]) {
        return [self.urlDB objectForKey: [originalURL absoluteString]];
    }
    NSString *chars = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSUInteger hash = originalURL.hash;
    NSMutableString *shortenedURLString = [NSMutableString new];
    while (hash > 0) {
        NSUInteger d = hash % chars.length;
        [shortenedURLString appendFormat:@"%C", [chars characterAtIndex: d]];
        hash /= chars.length;
    }
    NSURL *shortenedURL = [NSURL URLWithString:[NSString stringWithFormat: @"https://mytinyurl.com/%@", shortenedURLString]];
    [self.urlDB addEntriesFromDictionary:@{[originalURL absoluteString] : [shortenedURL absoluteString]}];
    [shortenedURLString release];
    return shortenedURL;
}

- (NSURL *)decode:(NSURL *)shortenedURL {
    if ([self.urlDB.allValues containsObject: [shortenedURL absoluteString]]) {
        NSURL *originalURL = [NSURL URLWithString: [self.urlDB allKeysForObject: [shortenedURL absoluteString]].firstObject];
        return originalURL;
    }
    return shortenedURL;
}

- (void)dealloc
{
    [_urlDB release];
    _urlDB = nil;
    [super dealloc];
}

@end
