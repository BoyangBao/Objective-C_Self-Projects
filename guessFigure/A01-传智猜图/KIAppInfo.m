//
//  KIAppInfo.m
//  A01-传智猜图
//
//  Created by boyang bao on 2/8/16.
//  Copyright © 2016 itcast. All rights reserved.
//

#import "KIAppInfo.h"

@implementation KIAppInfo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initWithDic: (NSDictionary *) dic
{
    if (self = [super init]) {
//        self.icon = dic[@"icon"];
//        self.title = dic[@"title"];
//        self.answer = dic[@"answer"];
//        self.options = dic[@"options"];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype) appInfo: (NSDictionary *) dic
{
    return [[self alloc] initWithDic:dic];
}


@end
