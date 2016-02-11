//
//  ViewController.m
//  图片浏览器
//
//  Created by boyang bao on 2/3/16.
//  Copyright © 2016 boyang bao. All rights reserved.
//

#import "ViewController.h"
#import "KIappInfo.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numImage;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *textIMG;

@property (weak, nonatomic) IBOutlet UIButton *preBTN;
@property (weak, nonatomic) IBOutlet UIButton *nextBTN;

@property (nonatomic,assign) int index;
@property (nonatomic,strong) NSArray* array;

- (void) change;

- (IBAction)right:(id)sender;
- (IBAction)left:(id)sender;

@end

@implementation ViewController

- (void) viewDidLoad
{
    self.index = 0;
    [self change];
    NSLog(@"%lu",(unsigned long)self.array.count);
}

- (NSArray *) array
{
    if (_array == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"imageData" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array_1 = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            KIappInfo *appInfo = [[KIappInfo alloc] init];
            appInfo.icon = dic[@"icon"];
            appInfo.desc = dic[@"desc"];
            [array_1 addObject:appInfo];
        }
        _array = array_1;
    }
    
    
    return _array;
};

- (void) change
{
    KIappInfo *appInfo = self.array[self.index];
    
    self.numImage.text = [NSString stringWithFormat:@"%d/%zd",self.index+1,self.array.count];
    
    [self.image setImage:[UIImage imageNamed:appInfo.icon]];
    
//    self.image.image = [UIImage imageNamed:appInfo.icon];
    
    self.textIMG.text = appInfo.desc;
    
    self.preBTN.enabled = (self.index == 0) ? NO : YES;
    
    self.nextBTN.enabled = (self.index == self.array.count-1) ? NO : YES;
    
    
}

- (IBAction)right:(id)sender {
    self.index ++;
    [self change];
}

- (IBAction)left:(id)sender {
    self.index --;
    [self change];
}
@end
