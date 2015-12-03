//
//  ViewController.m
//  MediaTest
//
//  Created by wxdtan on 15/12/2.
//  Copyright © 2015年 com.qianjiyuntong. All rights reserved.
//

#import "ViewController.h"
#import "SoundsViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)inClicked:(id)sender{
    
    SoundsViewController * vc = [[SoundsViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
