//
//  RARViewController.m
//  PDWebView
//
//  Created by pdxx on 2018/5/25.
//  Copyright © 2018年 pdxx. All rights reserved.
//

#import "RARViewController.h"
#import "RARFolderViewCell.h"
#import "QuickLookViewController.h"

@interface RARViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation RARViewController

- (void)onBackButtonItemClick{
    if (self.navigationController.viewControllers.count ==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onCloseButtonItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(onBackButtonItemClick)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(onCloseButtonItemClick)];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT -20) style:UITableViewStyleGrouped];
    self.tableView.tableFooterView =[UIView new];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    
    [self.dataShowArray removeAllObjects];
    NSLog(@"--------self.layerPath----%@",self.layerPath);
    self.title =self.layerTitle;
    for (URKFileInfo *info in self.dataArray) {
        NSString *dataStr =info.filename;
        if ([dataStr containsString:self.layerPath]) {
            NSLog(@"--------dataStr----%@",dataStr);
            NSArray *tempDataArr =[dataStr componentsSeparatedByString:@"/"];
            if (tempDataArr.count >self.layerIndex) {
                NSString *layerIndexStr =tempDataArr[self.layerIndex];
                if (![self.dataShowArray containsObject:layerIndexStr]) {
                    [self.dataShowArray addObject:layerIndexStr];
                }
                
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataShowArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index =indexPath.row;
    NSString *tempName =self.dataShowArray[index];
    NSString *tempStr =[@"/" stringByAppendingString:tempName];
    NSString *fileName =[self.layerPath stringByAppendingString:tempStr];
    
    RARFolderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RARFolderViewCell"];
    if (cell == nil)
    {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RARFolderViewCell" owner:self options:nil] lastObject];
    }
    for (URKFileInfo *info in self.dataArray) {
        if ([info.filename isEqual:fileName]) {
            if (info.isDirectory) {
                //文件夹
                cell.typeImageView.image =[UIImage imageNamed:@"folder"];
                cell.tipImageView.hidden =NO;
                cell.messageLabel.text =@"文件夹";
            }else{
                //文件
                cell.typeImageView.image =[UIImage imageNamed:@"file"];
                cell.tipImageView.hidden =YES;
                cell.messageLabel.text =[NSString stringWithFormat:@"文件大小：%@",[CommonHelper bytesToAvaiUnit:info.uncompressedSize]];
            }
        }
    }
    cell.folderName.text =tempName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index =indexPath.row;
    NSString *tempName =self.dataShowArray[index];
    NSString *tempStr =[@"/" stringByAppendingString:tempName];
    NSString *fileName =[self.layerPath stringByAppendingString:tempStr];
    for (URKFileInfo *info in self.dataArray) {
        if ([info.filename isEqual:fileName]) {
            if (info.isDirectory) {
                //点击文件夹
                RARViewController *rarVC =[[RARViewController alloc]init];
                rarVC.layerIndex =self.layerIndex +1;
                if (self.layerIndex ==0) {
                    rarVC.layerPath =self.layerPath;
                }else{
                    rarVC.layerPath =fileName;
                }
                rarVC.dataArray =self.dataArray;
                rarVC.layerTitle =tempName;
                [self.navigationController pushViewController:rarVC animated:YES];
                return;
            }else{
                //点击文件
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RARFiles"];
                NSString *tempStr =[@"/" stringByAppendingString:fileName];
                NSString *filePath =[path stringByAppendingString:tempStr];
                NSURL *fileUrl =[NSURL fileURLWithPath:filePath isDirectory:NO];
                if ([tempName hasSuffix:@".xls"] ||[tempName hasSuffix:@".doc"] ||[tempName hasSuffix:@".ppt"] ||[tempName hasSuffix:@".xlsx"] ||[tempName hasSuffix:@".docx"] ||[tempName hasSuffix:@".pptx"] ||[tempName hasSuffix:@".txt"] ||[tempName hasSuffix:@".pdf"]) {
                    QuickLookViewController *quickLookVC = [[QuickLookViewController alloc]init];
                    quickLookVC.fileURL = fileUrl;//本地文件的url
                    quickLookVC.titleName =fileName;
                    [self.navigationController pushViewController:quickLookVC animated:YES];
                    return;
                }else{
                    RIButtonItem *btnOK = [RIButtonItem
                                           itemWithLabel:@"是"
                                           action:^{
                                               self.documentController =[UIDocumentInteractionController interactionControllerWithURL:fileUrl];
                                               self.documentController.delegate =self;
                                               [self.documentController presentOpenInMenuFromRect:CGRectZero
                                                                                           inView:self.view
                                                                                         animated:YES];
                                           }];
                    RIButtonItem *btnCancel = [RIButtonItem
                                               itemWithLabel:@"否"
                                               action:^{
                                               }];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"文件暂不支持本地查看，是否尝试使用其他应用打开？"
                                                           cancelButtonItem:btnCancel
                                                           otherButtonItems:btnOK, nil];
                    [alert show];
                    return;
            }
        }
    }
}
}

#pragma mark -  懒加载

- (NSMutableArray *)dataShowArray{
    if (!_dataShowArray) {
        _dataShowArray =[NSMutableArray arrayWithCapacity:0];
    }
    return _dataShowArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
