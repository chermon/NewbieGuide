//
//  ViewController.m
//  UserGuidePage
//
//  Created by 陈梦 on 2018/8/29.
//  Copyright © 2018年 梦. All rights reserved.
//

#import "ViewController.h"
#import "CMGuidePageView.h"

@interface ViewController ()<CMGuidePageViewDelegate, CMGuidePageViewDataSource>
@property (nonatomic, strong) CMGuidePageView *guidePageView;
@property (nonatomic, strong) NSArray *cueWordArr;
@property (nonatomic, strong) NSArray *visualViewArr;
@end

@implementation ViewController

- (CMGuidePageView *)guidePageView{
    if(!_guidePageView){
        _guidePageView = [[CMGuidePageView alloc]initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _guidePageView.dataSource = self;
    }
    return _guidePageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *boxView1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y - 100, 50, 50)];
    boxView1.text = @"1";
    boxView1.textAlignment = NSTextAlignmentCenter;
    boxView1.backgroundColor = [UIColor greenColor];
    [self.view addSubview: boxView1];
    
    UILabel *boxView2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x + 100, self.view.center.y - 100, 50, 50)];
    boxView2.text = @"2";
    boxView2.textAlignment = NSTextAlignmentCenter;
    boxView2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: boxView2];
    
    UILabel *boxView3 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y + 100, 50, 50)];
    boxView3.text = @"3";
    boxView3.textAlignment = NSTextAlignmentCenter;
    boxView3.backgroundColor = [UIColor purpleColor];
    [self.view addSubview: boxView3];
    
    UILabel *boxView4 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x + 100, self.view.center.y + 100, 50, 50)];
    boxView4.text = @"4";
    boxView4.textAlignment = NSTextAlignmentCenter;
    boxView4.backgroundColor = [UIColor blueColor];
    [self.view addSubview: boxView4];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(enterNextPageAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Click on here" forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.center.x - 100, self.view.center.y - 44, 200, 80);
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview: btn];
    
    self.cueWordArr = @[@"It's green box", @"Please put orange into the orange box", @"The purple box is biggest",@"blue"];
    self.visualViewArr = @[boxView1, boxView2, boxView3, boxView4];
}

-(void)enterNextPageAction
{
    [self.guidePageView show];
}

#pragma mark - CMGuidePageViewDataSource

- (NSInteger)numberOfItemsInGuidePageView:(CMGuidePageView *)guidePageView{
    return self.cueWordArr.count;
}

- (UIView *)guidePageView:(CMGuidePageView *)guidePageView viewForItemAtIndex:(NSInteger)index{
    return self.visualViewArr[index];
}

- (NSString *)guidePageView:(CMGuidePageView *)guidePageView descriptionLabelForItemAtIndex:(NSInteger)index{
    return self.cueWordArr[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
