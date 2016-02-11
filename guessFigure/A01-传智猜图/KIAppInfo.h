//
//  KIAppInfo.h
//  A01-传智猜图
//
//  Created by boyang bao on 2/8/16.
//  Copyright © 2016 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIAppInfo : UIView

@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray *options;

- (instancetype) initWithDic: (NSDictionary *) dic;

+ (instancetype) appInfo: (NSDictionary *) dic;
@end
