//
//  CommonHelper.h
//  NFYY
//  公共辅助类
//  Created by Kingsley on 15/7/27.
//  Copyright (c) 2015年 Character Information. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

//适配文字高度
+ (CGFloat)stringHeight:(NSString *)str width:(CGFloat)width font:(int)font;

//解压rar文件
+ (NSMutableArray *)extractRARFile:(NSURL *)filePath;

// 将文件大小数据进行单位转换
+ (NSString *)bytesToAvaiUnit:(long long int)bytes;

@end
