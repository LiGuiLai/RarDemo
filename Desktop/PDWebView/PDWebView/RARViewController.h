//
//  RARViewController.h
//  PDWebView
//
//  Created by pdxx on 2018/5/25.
//  Copyright © 2018年 pdxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RARViewController : BaseViewController

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *dataShowArray;

@property (nonatomic ,assign) NSInteger layerIndex; //跳转到第几层文件夹
@property (nonatomic ,strong) NSString * layerPath; //跳转到的文件夹路径
@property (nonatomic ,strong) NSString * layerTitle; //跳转到的文件夹路径标题

@end
