//
//  SoundsViewController.h
//  MediaTest
//
//  Created by wxdtan on 15/12/2.
//  Copyright © 2015年 com.qianjiyuntong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundsViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIButton * button;
@property (nonatomic,strong) IBOutlet UIButton * buttonSing;

- (IBAction)playClicked:(id)sender;

- (IBAction)singClicked:(id)sender;


@end
