//
//  ViewController.m
//  汤姆
//
//  Created by boyang bao on 2/4/16.
//  Copyright © 2016 boyang bao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)eat:(id)sender;
- (IBAction)drink:(id)sender;
- (IBAction)pie:(id)sender;
- (IBAction)fart:(id)sender;
- (IBAction)scratch:(id)sender;


- (void) animationWithCount: (int) count imageName: (NSString *)name;

- (void) clearMemmory;
@end

@implementation ViewController


- (void) animationWithCount: (int) count imageName: (NSString *)name
{
    if (self.imageView.isAnimating) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int index = 0; index < count; index++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%02d",name,index];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        //解决 imagenamed内存无限增大
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [array addObject:image];
    }
    
    self.imageView.animationImages = array;
    
    self.imageView.animationDuration = 3;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    //清空内存
    [self.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.imageView.animationDuration+0.1];
}

- (void) clearMemmory
{
    self.imageView.animationImages = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)eat:(id)sender {
    [self animationWithCount:39 imageName:@"eat"];
}

- (IBAction)drink:(id)sender {
    [self animationWithCount:80 imageName:@"drink"];
}

- (IBAction)pie:(id)sender {
    [self animationWithCount:23 imageName:@"pie"];
}

- (IBAction)fart:(id)sender {
    [self animationWithCount:27 imageName:@"fart"];
}

- (IBAction)scratch:(id)sender {
    [self animationWithCount:55 imageName:@"scratch"];
}
@end
