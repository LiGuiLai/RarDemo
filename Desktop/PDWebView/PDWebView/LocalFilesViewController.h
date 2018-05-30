//
//  LocalFilesViewController.h
//  NFYY
//
//  Created by pdxx on 2018/5/11.
//  Copyright © 2018年 Character Information. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocalFilesViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *localBtn;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isLocal; //YES为本地文件列表；NO为下载文件列表
@property (nonatomic, strong) NSMutableArray *sourceArr; //文件数据集合
@property (nonatomic,strong) NSMutableArray *actionArray; //单元格左滑动作集合



@end
