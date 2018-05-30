//
//  QuickLookViewController.h
//  JSZY
//
//  Created by pdxx on 2018/1/3.
//  Copyright © 2018年 Character Information. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface QuickLookViewController : BaseViewController

@property (nonatomic,strong) QLPreviewController *previewController;
@property (nonatomic,retain) NSURL *fileURL;
@property (nonatomic,strong) NSString *titleName;

@end
