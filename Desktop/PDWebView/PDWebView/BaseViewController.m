//
//  BaseViewController.m
//  NFYY
//
//  Created by 品德信息 on 2017/9/7.
//  Copyright © 2017年 Character Information. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //iPhone X的适配
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect = self.navigationController.navigationBar.frame;
    
    self.navHeight = StatusRect.size.height + NavRect.size.height;
    
}


#pragma mark - UIDocumentInteractionControllerDelegate


- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}





@end
