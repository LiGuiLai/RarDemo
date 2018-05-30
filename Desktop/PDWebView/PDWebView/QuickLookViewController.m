//
//  QuickLookViewController.m
//  JSZY
//
//  Created by pdxx on 2018/1/3.
//  Copyright © 2018年 Character Information. All rights reserved.
//

#import "QuickLookViewController.h"

@interface QuickLookViewController () <QLPreviewControllerDataSource,
QLPreviewControllerDelegate>

@end

@implementation QuickLookViewController

#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleName;
    
    [self.previewController reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- QLPreviewControllerDataSource,QLPreviewControllerDelegate

- (id)previewController:(QLPreviewController *)controller previewItemAtIndex: (NSInteger) index{
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

#pragma mark- 懒加载

- (QLPreviewController *)previewController{
    if (!_previewController) {
        _previewController = [[QLPreviewController alloc] init];
        _previewController.dataSource = self;
        _previewController.delegate = self;
        _previewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
        _previewController.currentPreviewItemIndex = 0;
        [self addChildViewController:_previewController];
        [self.view addSubview:_previewController.view];
    }
    return _previewController;
}



/*
 @implementation QLPreviewController(swizzled)
 
 +(void) load
 {
 [super load];
 Method fromObjectAtIndex = class_getInstanceMethod(objc_getClass("QLPreviewController"), @selector(viewWillAppear:));
 Method toObjectAtIndex = class_getInstanceMethod(objc_getClass("QLPreviewController"), @selector(myViewWillAppear:));
 method_exchangeImplementations(fromObjectAtIndex, toObjectAtIndex);
 }
 
 -(void) myViewWillAppear:(BOOL)animated
 {
 [self myViewWillAppear:animated];
 if (self.navigationItem.rightBarButtonItems.count >0)
 {
 [self.navigationItem.rightBarButtonItems[0] setValue:@(YES) forKey:@"hidden"];
 }
 }
 
 @end
*/

@end
