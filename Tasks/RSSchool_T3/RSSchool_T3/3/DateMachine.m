#import "DateMachine.h"

@interface DateMachine() <UITextFieldDelegate>

@end

@implementation DateMachine
- (void)viewDidLoad {
    [super viewDidLoad];
    // have fun
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    UITextField *startTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, [self.view bounds].size.width - 20, 30)];
    startTextField.placeholder = @"Start date";
    startTextField.delegate = self;
    startTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    startTextField.layer.borderWidth = 1;
    startTextField.backgroundColor = [UIColor whiteColor];
    [startTextField setLeftView: left];
    startTextField.leftViewMode = UITextFieldViewModeAlways;
    [left release];
    startTextField.tag = 11;
    
    left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    UITextField *stepTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, [self.view bounds].size.width - 20, 30)];
    stepTextField.placeholder = @"Step";
    stepTextField.delegate = self;
    stepTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    stepTextField.layer.borderWidth = 1;
    stepTextField.backgroundColor = [UIColor whiteColor];
    [stepTextField setLeftView: left];
    stepTextField.leftViewMode = UITextFieldViewModeAlways;
    [left release];
    stepTextField.tag = 12;
    
    left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    UITextField *unitTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, [self.view bounds].size.width - 20, 30)];
    unitTextField.placeholder = @"Date unit";
    unitTextField.delegate = self;
    unitTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    unitTextField.layer.borderWidth = 1;
    unitTextField.backgroundColor = [UIColor whiteColor];
    [unitTextField setLeftView: left];
    unitTextField.leftViewMode = UITextFieldViewModeAlways;
    [left release];
    unitTextField.tag = 13;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, [self.view bounds].size.width / 2 - 10, 30)];
    addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(performOperation:) forControlEvents:UIControlEventTouchUpInside];
    addButton.backgroundColor = [UIColor grayColor];
    addButton.layer.cornerRadius = 7;
    addButton.layer.borderWidth = 1;
    addButton.layer.borderColor = [[UIColor blackColor] CGColor];
    addButton.tag = 21;
    
    UIButton *subButton = [[UIButton alloc] initWithFrame:CGRectMake([self.view bounds].size.width / 2 + 10, 250, [self.view bounds].size.width / 2 - 20, 30)];
    subButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [subButton setTitle:@"Sub" forState:UIControlStateNormal];
    [subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subButton addTarget:self action:@selector(performOperation:) forControlEvents:UIControlEventTouchUpInside];
    subButton.backgroundColor = [UIColor grayColor];
    subButton.layer.cornerRadius = 7;
    subButton.layer.borderWidth = 1;
    subButton.layer.borderColor = [[UIColor blackColor] CGColor];
    subButton.tag = 22;
    
    UILabel *outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, [self.view bounds].size.width, 30)];
    outputLabel.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    outputLabel.text = [dateFormatter stringFromDate: [NSDate date]];
    outputLabel.backgroundColor = [UIColor whiteColor];
    outputLabel.tag = 31;
    
    [self.view addSubview: startTextField];
    [self.view addSubview: stepTextField];
    [self.view addSubview: unitTextField];
    [self.view addSubview: addButton];
    [self.view addSubview: subButton];
    [self.view addSubview: outputLabel];
    [startTextField release];
    [stepTextField release];
    [unitTextField release];
    [addButton release];
    [subButton release];
    [outputLabel release];
}

- (void) performOperation:(id) sender {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    UILabel *outputLabel = [self.view viewWithTag: 31];
    NSDate *startDate = [dateFormatter dateFromString: outputLabel.text];
    if (!startDate) {
        return;
    }
    UITextField *stepTextField = [self.view viewWithTag: 12];
    NSScanner *scanner = [NSScanner scannerWithString: stepTextField.text];
    int step = 0;
    if (![scanner scanInt: &step]) {
        return;
    }
    UITextField *unitTextField = [self.view viewWithTag: 13];
    NSString *unit = [unitTextField.text lowercaseString];
    NSArray *units = @[@"year", @"month", @"week", @"day", @"hour", @"minute"];
    if (![units containsObject: unit]) {
        unitTextField.backgroundColor = [UIColor redColor];
        return;
    } else {
        unitTextField.backgroundColor = [UIColor whiteColor];
    }
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit;
    switch ([units indexOfObject: unit]) {
        case 0:
            calendarUnit = NSCalendarUnitYear;
            break;
        case 1:
            calendarUnit = NSCalendarUnitMonth;
            break;
        case 2: {
            calendarUnit = NSCalendarUnitDay;
            step *= 7;
            break;
        }
        case 3:
            calendarUnit = NSCalendarUnitDay;
            break;
        case 4:
            calendarUnit = NSCalendarUnitHour;
            break;
        case 5:
            calendarUnit = NSCalendarUnitMinute;
            break;
        default:
            return;
    }
    if (((UIButton *)sender).tag == 22) {
        step = -step;
    }
    NSDate *newDate = [gregorian dateByAddingUnit: calendarUnit value: step toDate: startDate options: nil];
    outputLabel.text = [dateFormatter stringFromDate: newDate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string.length)
    {
        return YES;
    }
    switch (textField.tag) {
        case 11: { // The dates should be in format 20/04/2004 04:20
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
            NSString *newText = [textField.text stringByReplacingCharactersInRange: range withString: string];
            if ([dateFormatter dateFromString: newText]) {
                UILabel *outputLabel = [self.view viewWithTag: 31];
                outputLabel.text = newText;
            }
            return YES;
        }
        case 12: { // "Step" text field should allow only numbers
            if ([string rangeOfCharacterFromSet: [NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound) {
                return NO;
            }
            return YES;
        }
        case 13: { // "Date unit" should only allow these values: year, month, week, day, hour, minute
            if ([string rangeOfCharacterFromSet: [NSCharacterSet letterCharacterSet].invertedSet].location != NSNotFound) {
                return NO;
            }
            return YES;
        }
        default:
            break;
    }
    return NO;
}

@end
