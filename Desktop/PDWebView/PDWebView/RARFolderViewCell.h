//
//  RARFolderViewCell.h
//  NFYY
//
//  Created by pdxx on 2018/5/25.
//  Copyright © 2018年 Character Information. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RARFolderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *folderName;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
