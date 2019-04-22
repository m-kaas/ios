//
//  PhoneNumber.h
//  RSSchool_T4
//
//  Created by Liubou Sakalouskaya on 4/19/19.
//  Copyright © 2019 iOSLab. All rights reserved.
//

@interface PhoneNumber : NSObject

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy, readonly) NSString *country;

-(NSString *)countryFlag;

@end
