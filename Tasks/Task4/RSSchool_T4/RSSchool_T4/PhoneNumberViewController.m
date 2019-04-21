//
//  PhoneNumberViewController.m
//  RSSchool_T4
//
//  Created by Liubou Sakalouskaya on 4/19/19.
//  Copyright © 2019 iOSLab. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "PhoneNumber.h"

@interface PhoneNumberViewController () <UITextFieldDelegate>

@property (nonatomic, retain) PhoneNumber *phoneNumber;

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.phoneNumber) {
        self.phoneNumber = [PhoneNumber new];
    }
    self.view.backgroundColor = [UIColor lightGrayColor];
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame: CGRectMake(30, self.view.bounds.size.height / 2, self.view.bounds.size.width - 60, 50)];
    phoneTextField.tag = 11;
    phoneTextField.delegate = self;
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.layer.borderWidth = 1;
    phoneTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    phoneTextField.layer.cornerRadius = 7;
    phoneTextField.placeholder = @"+";
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    UILabel *flagView = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50, 50)];
    flagView.tag = 21;
    flagView.textAlignment = NSTextAlignmentCenter;
    [phoneTextField setLeftViewMode: UITextFieldViewModeAlways];
    [phoneTextField setLeftView: flagView];
    [flagView release];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(phoneNumberChanged:) name:  UITextFieldTextDidChangeNotification object: phoneTextField];
    [self.view addSubview: phoneTextField];
    [phoneTextField release];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        NSString *text = [textField.text substringWithRange: range];
        if ([text isEqualToString: @")"] ||
            [text isEqualToString: @"-"] ||
            [text isEqualToString: @" "]) {
            textField.text = [textField.text substringToIndex: textField.text.length - 1];
        }
        return YES;
    }
    if ([string rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"+0123456789"].invertedSet].location != NSNotFound) {
        return NO;
    }
    return YES;
}

- (void)phoneNumberChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    self.phoneNumber.number = textField.text;
    UILabel *flagLabel = [textField viewWithTag: 21];
    flagLabel.text = [self.phoneNumber countryFlag];
    textField.text = self.phoneNumber.number;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_phoneNumber release];
    [super dealloc];
}

@end
