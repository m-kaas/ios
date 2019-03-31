#import "DoomsdayMachine.h"

@interface AssimilationDate : NSObject <AssimilationInfo>
- (instancetype)initWithDateComponents:(NSDateComponents *)components;
@end

@interface DoomsdayMachine()
+ (NSDate *)dateFromBorg:(NSString *)date;
@end

@implementation AssimilationDate

@synthesize seconds = _seconds;
@synthesize minutes = _minutes;
@synthesize hours = _hours;
@synthesize days = _days;
@synthesize weeks = _weeks;
@synthesize months = _months;
@synthesize years = _years;

- (instancetype)initWithDateComponents:(NSDateComponents *)components {
    [components retain];
    self = [super init];
    if (self) {
        _years = components.year;
        _months = components.month;
        _days = components.day;
        _hours = components.hour;
        _minutes = components.minute;
        _seconds = components.second;
    }
    [components release];
    return self;
}

@end

@implementation DoomsdayMachine
- (NSString *)doomsdayString {
    NSString *assimilationDateString = @"2208:08:14@37\\13/03";
    NSDate *assimilationDate = [DoomsdayMachine dateFromBorg:assimilationDateString];
    NSDateFormatter *humanFormatter = [NSDateFormatter new];
    humanFormatter.dateFormat = @"EEEE, MMMM dd, yyyy";
    NSString *humanDate = [humanFormatter stringFromDate:assimilationDate];
    [humanFormatter release];
    return humanDate; //Sunday, August 14, 2208
}
+ (NSDate *)dateFromBorg:(NSString *)date {
    [date retain];
    NSDateFormatter *borgFormatter = [NSDateFormatter new];
    borgFormatter.dateFormat = @"yyyy:MM:dd@ss\\mm/HH";
    NSDate *inputDate = [borgFormatter dateFromString:date];
    [borgFormatter release];
    [date release];
    return inputDate;
}
- (id<AssimilationInfo>)assimilationInfoForCurrentDateString:(NSString *)dateString {
    NSString *assimilationDateString = @"2208:08:14@37\\13/03";
    NSDate *currentDate = [DoomsdayMachine dateFromBorg:dateString];
    NSDate *assimilationDate = [DoomsdayMachine dateFromBorg:assimilationDateString];
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [gregorian components: unitFlags fromDate:currentDate toDate:assimilationDate options:0];
    AssimilationDate *wrapper = [[AssimilationDate alloc] initWithDateComponents:components];
    return [wrapper autorelease];
}
@end
