//
//  ViewController.m
//  A01-传智猜图
//
//  Created by Apple on 14/12/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "KIAppInfo.h"
@interface ViewController ()




@property (weak, nonatomic) IBOutlet UILabel *countView;
@property (weak, nonatomic) IBOutlet UIButton *coinView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIButton *iconView;

//记录图片按钮的原始位置
@property (nonatomic, assign) CGRect oldFrame;

//遮盖的按钮
@property (nonatomic, weak) UIButton *coverView;

//字典转模型
@property (nonatomic, strong) NSArray *KIQuestion;

//创建索引
@property (nonatomic, assign) int index;

//控制
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//答案View
@property (weak, nonatomic) IBOutlet UIView *answerView;
//选项View
@property (weak, nonatomic) IBOutlet UIView *OptionView;

- (IBAction)tipClick;
- (IBAction)helpClick;
- (IBAction)bigImageClick;
- (IBAction)nextClick;



@end

@implementation ViewController

- (NSArray *) KIQuestion
{
    if (_KIQuestion == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
        NSArray *tmp = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *trans = [NSMutableArray array];
        for (NSDictionary *dic in tmp) {
            KIAppInfo *appInfo = [[KIAppInfo alloc] initWithDic:dic];
            [trans addObject:appInfo];
        }
        _KIQuestion = trans;
    }
    return _KIQuestion;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%@",NSHomeDirectory());
    self.index--;
    [self nextClick];


}


- (IBAction)tipClick {
}

- (IBAction)helpClick {
}

//1 点击放大图片
- (IBAction)bigImageClick {

    //记录原始的frame
    self.oldFrame = self.iconView.frame;
    
    //1.1  放大图片
    CGFloat iconW = self.view.frame.size.width;
    CGFloat iconH = iconW;
    CGFloat iconX = 0;
    CGFloat iconY = (self.view.frame.size.height - iconH) / 2;
    
    //1.3 生成遮盖的view （按钮）
    UIButton *coverView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:coverView];
    
    self.coverView = coverView;
    
    coverView.frame = self.view.bounds;
    
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    
    //1.4 把一个子控件置于顶层
    [self.view bringSubviewToFront:self.iconView];
    
    //1.2 动画
    [UIView animateWithDuration:1.0 animations:^{
        self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
        coverView.alpha = 0.5;
    }];
    
    //1.5 点击遮盖层 缩小图片
    [coverView addTarget:self action:@selector(smallImageClick) forControlEvents:UIControlEventTouchUpInside];
}

//1.5 点击遮盖层 缩小图片
- (void)smallImageClick
{
    [UIView animateWithDuration:1.0 animations:^{
        self.iconView.frame = self.oldFrame;
        self.coverView.alpha = 0;
        
    } completion:^(BOOL finished) {
        //当动画完成之后，移除遮盖按钮
        [self.coverView removeFromSuperview];

    }];
}
//1.6 点击图片按钮。放大或缩小
- (IBAction)iconClick {
    if (self.coverView == nil) {
        [self bigImageClick];
    }else{
        [self smallImageClick];
    }
}


- (IBAction)nextClick {
    self.OptionView.userInteractionEnabled = YES;
     self.index++;
    
    if (self.index == self.KIQuestion.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"恭喜你完成了" delegate:self cancelButtonTitle:@"退下吧" otherButtonTitles:@"知道了 滚吧！", nil];
        [alert show];
        return;
    }
    
    KIAppInfo *appInfo = self.KIQuestion[self.index];
    
    self.countView.text = [NSString stringWithFormat:@"%d/%lu",self.index+1,self.KIQuestion.count];
    
    [self.iconView setImage:[UIImage imageNamed:appInfo.icon] forState:UIControlStateNormal];
    
    self.titleView.text = appInfo.title;
    
    self.nextBtn.enabled = (self.index == self.KIQuestion.count -1)? NO : YES;
    
    [self answerButton:appInfo];
    [self optionButton:appInfo];
}

- (void) answerButton: (KIAppInfo *) appInfo
{
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UIButton *btn in self.answerView.subviews) {
        [btn removeFromSuperview];
    }
    
    NSUInteger count = appInfo.answer.length;
    for (int i = 0; i < appInfo.answer.length; i++) {
        UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.answerView addSubview:answerBtn];
        CGFloat ansW = 35;
        CGFloat ansH = 35;
        CGFloat margin = 10;
        CGFloat marginaLeft = (self.answerView.frame.size.width - ansW*count - (count-1)* margin) / 2;
        
        CGFloat ansY = 0;
        CGFloat ansX = marginaLeft + i * (ansW + margin);
        
        answerBtn.frame = CGRectMake(ansX, ansY, ansW, ansH);
        [answerBtn setBackgroundColor:[UIColor grayColor]];
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) optionButton: (KIAppInfo *) appInfo
{
    [self.OptionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat optionW = 35;
    CGFloat optionH = 35;
    int totalColumn = 7;
    CGFloat marginX = (self.view.frame.size.width - totalColumn * optionW) / (totalColumn + 1);
    CGFloat marginY = 15;

    for (int i = 0; i < appInfo.options.count; i++) {
        int row = i / totalColumn;
        
        int column = i % totalColumn;
        
        CGFloat X = marginX + column *(optionW + marginX);
        
        CGFloat Y = row * (optionH + marginY);
        
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.OptionView addSubview:optionBtn];
        
        optionBtn.tag = i;
        
        optionBtn.frame = CGRectMake(X, Y, optionW, optionH);
        
        optionBtn.backgroundColor = [UIColor grayColor];
        
        [optionBtn setTitle:appInfo.options[i] forState:UIControlStateNormal];
        
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void) optionClick: (UIButton *) sender
{
    sender.hidden = YES;
    for (UIButton *answerBtn in self.answerView.subviews) {
        if (answerBtn.currentTitle == nil) {
            [answerBtn setTitle:sender.currentTitle forState:UIControlStateNormal];
            answerBtn.tag = sender.tag;
            break;
        }
    }
    
    BOOL isFull = YES;
     NSMutableString *tmp = [NSMutableString string];
    
    for (UIButton *answerBtn in self.answerView.subviews) {
        if (answerBtn.currentTitle == nil) {
            isFull = NO;
            break;
        }
        [tmp appendString:answerBtn.currentTitle];
    }
    
    KIAppInfo *question = self.KIQuestion[self.index];
    
    if (isFull) {
        self.OptionView.userInteractionEnabled = NO;
        
        if ([tmp isEqualToString:question.answer]) {
            
            for (UIButton *btn in self.answerView.subviews) {
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
                
                int count = [self.coinView.currentTitle intValue];
                
                count += 500;
                
                [self.coinView setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
                
                [self performSelector:@selector(nextClick) withObject:nil afterDelay:1.0];
            
        } else {
            for (UIButton *ansBtn in self.answerView.subviews) {
                
                [ansBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
            }
            int count = [self.coinView.currentTitle intValue];
            
            count -= 500;
            
            [self.coinView setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
            
        }
    }
    
}

- (void) answerClick: (UIButton *) sender
{
    self.OptionView.userInteractionEnabled = YES;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (sender.currentTitle == nil) {
        return;
    }
    
    for (UIButton *optionBtn in self.OptionView.subviews) {
        if (sender.tag == optionBtn.tag) {
            optionBtn.hidden = NO;
            break;
        }
    }
    [sender setTitle:nil forState:UIControlStateNormal];
}
@end
