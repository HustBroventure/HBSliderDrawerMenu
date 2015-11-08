//
//  HBMenuTableViewController.h
//  HBSliderDrawerMenu
//
//  Created by wangfeng on 15/11/8.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuCallBackDelegate <NSObject>

-(void)didSelectRowAtIndex:(NSUInteger)index;

@end
@interface HBMenuTableViewController : UITableViewController

@property (nonatomic, weak) id<MenuCallBackDelegate> delegate;
@end
