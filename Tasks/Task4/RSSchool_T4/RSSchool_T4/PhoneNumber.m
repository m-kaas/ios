//
//  PhoneNumber.m
//  RSSchool_T4
//
//  Created by Liubou Sakalouskaya on 4/19/19.
//  Copyright © 2019 iOSLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumber.h"

@interface PhoneNumber ()

@property (nonatomic, copy) NSString *country;

@end

@implementation PhoneNumber

- (instancetype)init
{
    self = [super init];
    if (self) {
        _country = [@"NULL" retain];
        _number = [NSString new];
    }
    return self;
}

- (void)setNumber:(NSString *)number {
    if ([number isEqualToString: _number]) {
        return;
    }
    if (number.length == 0) {
        [_number release];
        _number = [NSString new];
        return;
    }
    NSString *newNumber = [[number componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"+() -"]] componentsJoinedByString: @""];
    if (newNumber.length == 0) {
        [_number release];
        _number = [@"+" retain];
        return;
    }
    NSString *code = [newNumber substringToIndex: MIN(3, newNumber.length)];
    NSString *oldCountry = self.country;
    if ([code hasPrefix: @"7"] && code.length > 1) {
        if ([code hasPrefix: @"77"]) {
            self.country = @"KZ";
        } else {
            self.country = @"RU";
        }
    } else {
        self.country = [PhoneNumber countryByCode: code];
    }
    NSString *numberWhithoutCode = [newNumber substringFromIndex: [self countryCode].length];
    NSUInteger numL = numberWhithoutCode.length;
    if (numL > [self estimatedLength]) {
        self.country = oldCountry;
        return;
    }
    NSMutableString *numberString = [NSMutableString stringWithFormat: @"+ %@", [self countryCode]];
    if ([self estimatedLength] == 12) {
        [numberString appendString: newNumber];
    } else if ([self estimatedLength] == 8 || [self estimatedLength] == 9) { // 8: (2) 3-3, 9: (2) 3-2-2
        if (numL > 0) {
            [numberString appendString: @" ("];
            [numberString appendString: [numberWhithoutCode substringToIndex: MIN(2, numL)]];
            if (numL >= 2) {
                [numberString appendString: @")"];
                if (numL > 2) {
                    [numberString appendString: @" "];
                    [numberString appendString: [numberWhithoutCode substringWithRange: NSMakeRange(2, MIN(3, numL - 2))]];
                    if (numL >= 5) {
                        [numberString appendString: @"-"];
                        if (numL > 5) {
                            if ([self estimatedLength] == 9) {
                                [numberString appendString: [numberWhithoutCode substringWithRange: NSMakeRange(5, MIN(2, numL - 5))]];
                                if (numL >= 7) {
                                    [numberString appendString: @"-"];
                                    if (numL > 7) {
                                        [numberString appendString: [numberWhithoutCode substringFromIndex: 7]];
                                    }
                                }
                            } else {
                                [numberString appendString: [numberWhithoutCode substringFromIndex: 5]];
                            }
                        }
                    }
                }
            }
        }
    } else if ([self estimatedLength] == 10) { // (3) 3 2 2
        if (numL > 0) {
            [numberString appendString: @" ("];
            [numberString appendString: [numberWhithoutCode substringToIndex: MIN(3, numL)]];
            if (numL >= 3) {
                [numberString appendString: @")"];
                if (numL > 3) {
                    [numberString appendString: @" "];
                    [numberString appendString: [numberWhithoutCode substringWithRange: NSMakeRange(3, MIN(3, numL - 3))]];
                    if (numL >= 6) {
                        [numberString appendString: @" "];
                        if (numL > 6) {
                            [numberString appendString: [numberWhithoutCode substringWithRange: NSMakeRange(6, MIN(2, numL - 6))]];
                            if (numL >= 8) {
                                [numberString appendString: @" "];
                                if (numL > 8) {
                                    [numberString appendString: [numberWhithoutCode substringFromIndex: 8]];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    [_number release];
    _number = [numberString copy];
}

- (NSUInteger)estimatedLength {
    if ([@[@"MD", @"AM", @"TM"] containsObject: self.country]) {
        return 8;
    }
    if ([@[@"BY", @"UA", @"TJ", @"AZ", @"KG", @"UZ"] containsObject: self.country]) {
        return 9;
    }
    if ([@[@"RU", @"KZ"] containsObject: self.country]) {
        return 10;
    }
    return 12;
}

- (NSString *)countryFlag {
    NSDictionary *flags = @{@"RU": @"🇷🇺", @"KZ": @"🇰🇿", @"MD": @"🇲🇩", @"AM": @"🇦🇲", @"BY": @"🇧🇾", @"UA": @"🇺🇦", @"TJ": @"🇹🇯", @"TM": @"🇹🇲", @"AZ": @"🇦🇿", @"KG": @"🇰🇬", @"UZ": @"🇺🇿", @"NULL": @""};
    return flags[self.country];
}

- (NSString *)countryCode {
    NSDictionary *codes = @{@"RU": @"7", @"KZ": @"7", @"MD": @"373", @"AM": @"374", @"BY": @"375", @"UA": @"380", @"TJ": @"992", @"TM": @"993", @"AZ": @"994", @"KG": @"996", @"UZ": @"998", @"NULL": @""};
    return codes[self.country];
}

+ (NSString *)countryByCode:(NSString *)code {
    NSDictionary *countries = @{@"373": @"MD", @"374": @"AM", @"375": @"BY", @"380": @"UA", @"992": @"TJ", @"993": @"TM", @"994": @"AZ", @"996": @"KG", @"998": @"KG"};
    if ([countries.allKeys containsObject: code]) {
        return countries[code];
    } else {
        return @"NULL";
    }
}

- (void)dealloc
{
    [_country release];
    [_number release];
    [super dealloc];
}

@end
