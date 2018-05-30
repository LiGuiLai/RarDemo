//
//  LocalFilesViewController.m
//  NFYY
//
//  Created by pdxx on 2018/5/11.
//  Copyright © 2018年 Character Information. All rights reserved.
//

#import "LocalFilesViewController.h"
#import "QuickLookViewController.h"
#import "RARNavigationController.h"
#import "RARViewController.h"

@interface LocalFilesViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, strong) UIView *instructionsView;

@end

@implementation LocalFilesViewController

- (IBAction)onFileTypeBtnClick:(UIButton *)sender {
    //本地按钮tag值：66   下载按钮tag值：88
    if (sender.tag ==66) {
        self.isLocal =YES;
        sender.selected =YES;
        self.downLoadBtn.selected =NO;
    }else{
        self.isLocal =NO;
        sender.selected =YES;
        self.localBtn.selected =NO;
    }
    [self moveTheInstructionsView:sender];
    [self loadData];
}

#pragma mark - ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"文件夹";
    self.actionArray =[NSMutableArray arrayWithCapacity:0];
    self.sourceArr =[NSMutableArray arrayWithCapacity:0];
    self.isLocal =YES;
    [self.localBtn.superview addSubview:self.instructionsView];
    
    self.tableView.tableFooterView =[UIView new];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新加载


//请求数据
- (void)loadData
{
    [self.sourceArr removeAllObjects];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if (self.isLocal) {
        //第三方应用拷贝过来的文件
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Inbox"];
        
        NSArray *arr = [fileManager subpathsAtPath:path];
        [self.sourceArr addObjectsFromArray:arr];
    }else{
        //下载并存在沙盒的文件

    }
    
    [self.tableView reloadData];
}


#pragma mark - TableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index =indexPath.row;
    NSString *fileName;
    if (self.isLocal) {
        fileName =self.sourceArr[index];
    }else{
        
    }
    CGFloat titleH =[CommonHelper stringHeight:fileName width:SCREEN_WIDTH -20 font:15];
    return 40 +titleH;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index =indexPath.row;
    NSString *fileName;
    if (self.isLocal) {
        fileName =self.sourceArr[index];
    }else{
       
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        //通过xib的名称加载自定义的cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines =0;
    cell.textLabel.text =fileName;
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    cell.textLabel.textColor =[UIColor lightGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index =indexPath.row;
    NSString *fileName;
    NSString *path;
    if (self.isLocal) {
        fileName =self.sourceArr[index];
        path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Inbox"] stringByAppendingPathComponent:fileName];
    }else{
        
    }
    NSURL *url= [NSURL fileURLWithPath:path isDirectory:NO];
    if ([fileName hasSuffix:@".xls"] ||[fileName hasSuffix:@".doc"] ||[fileName hasSuffix:@".ppt"] ||[fileName hasSuffix:@".xlsx"] ||[fileName hasSuffix:@".docx"] ||[fileName hasSuffix:@".pptx"] ||[fileName hasSuffix:@".txt"] ||[fileName hasSuffix:@".pdf"]) {
        QuickLookViewController *quickLookVC = [[QuickLookViewController alloc]init];
        quickLookVC.fileURL = url;//本地文件的url
        quickLookVC.titleName =fileName;
        [self.navigationController pushViewController:quickLookVC animated:YES];
    }else{
        if ([fileName hasSuffix:@".rar"]) {
            NSMutableArray *arr=[CommonHelper extractRARFile:url];
            if (arr !=nil) {
                RARViewController *rarVC =[[RARViewController alloc] init];
                rarVC.dataArray =arr;
                rarVC.layerIndex =1;
                rarVC.layerTitle =fileName;
                URKFileInfo *info =arr[0];
                NSString *dataStr =info.filename;
                NSArray *tempDataArr =[dataStr componentsSeparatedByString:@"/"];
                rarVC.layerPath =tempDataArr[0];
                RARNavigationController *rarNavController =[[RARNavigationController alloc]initWithRootViewController:rarVC];
                [self presentViewController:rarNavController animated:YES completion:nil];
                return;
            }else{
                RIButtonItem *btnOK = [RIButtonItem
                                       itemWithLabel:@"是"
                                       action:^{
                                           self.documentController =[UIDocumentInteractionController interactionControllerWithURL:url];
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
                                                                message:@"暂不支持解压该rar文件，是否尝试使用其他应用打开？"
                                                       cancelButtonItem:btnCancel
                                                       otherButtonItems:btnOK, nil];
                [alert show];
            }
        }else{
            self.documentController =[UIDocumentInteractionController interactionControllerWithURL:url];
            self.documentController.delegate =self;
            [self.documentController presentPreviewAnimated:YES];
        }
    }
}

#pragma mark - ViewCommonHelper

//移动标签
- (void)moveTheInstructionsView:(UIButton *)sender{
    CGPoint point = self.instructionsView.center;
    CGFloat time = 0.33;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    point.x = sender.center.x;
    [self.instructionsView setCenter:point];
    [UIView commitAnimations];
}

#pragma mark - 懒加载

- (UIView *)instructionsView{
    if (!_instructionsView) {
        _instructionsView =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 -40, 50 -2, 80, 2)];
        _instructionsView.backgroundColor =[UIColor redColor];
    }
    return _instructionsView;
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
