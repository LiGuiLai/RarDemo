//
//  CommonHelper.m
//  NFYY
//  公共辅助类
//  Created by Kingsley on 15/7/27.
//  Copyright (c) 2015年 Character Information. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

//适配文字高度
+ (CGFloat)stringHeight:(NSString *)str width:(CGFloat)width font:(int)font{
    float height=[str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;
    return height;
}

//解压rar文件
+ (NSMutableArray *)extractRARFile:(NSURL *)filePath{
    
    //解压文件前先清理 RARFiles的文件
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RARFiles"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    
    //创建文件解压器
    NSError *archiveError = nil;
    URKArchive *archive = [[URKArchive alloc] initWithURL:filePath error:&archiveError];
    if (!archive) {
        debugLog(@"URKArchive -- 文件不存在");
        return nil;
    }
    
    NSError *error = nil;
    NSMutableArray *rarModelArr =[NSMutableArray arrayWithCapacity:0];
    NSArray<URKFileInfo*> *fileInfosInArchive = [archive listFileInfo:&error];
    if (error) {
        debugLog(@"URKArchive --获取文件信息失败---%@",error);
        return nil;
    }
    for (URKFileInfo *info in fileInfosInArchive) {
//        debugLog(@"文件归档名: %@ /n 文件名: %@ /n 文件大小: %lld /n 是否是目录: %d", info.archiveName, info.filename, info.uncompressedSize ,info.isDirectory);
        [rarModelArr addObject:info];
        
        debugLog(@"%@", info.filename);
        [rarModelArr addObject:info];
    }
    
    //在沙盒新建一个文件目录,把解压的文件放在 RARFiles 文件夹下
    NSString *rarPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RARFiles"];
    if (![fileManager fileExistsAtPath:rarPath]) {
        BOOL blCreateFolder= [fileManager createDirectoryAtPath:rarPath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (blCreateFolder) {
            debugLog(@"RARFiles文件夹新建成功");
        }else {
            debugLog(@"RARFiles文件夹新建失败");
        }
    }else {
        debugLog(@"RARFiles文件夹已经存在沙盒");
    }
    
    BOOL extractFilesSuccessful = [archive extractFilesTo:rarPath overwrite:NO progress:^(URKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
        
        debugLog(@"Extracting %@: %f%% complete", currentFile.filename, percentArchiveDecompressed);
        
    } error:&error];
    
    if (error) {
        debugLog(@"URKArchive --归档文件信息失败---%@",error);
        return nil;
    }
    
    if (extractFilesSuccessful ==NO) {
        debugLog(@"URKArchive --归档文件信息失败");
        return nil;
    }else{
        return rarModelArr;
    }
}

// 将文件大小数据进行单位转换
+ (NSString *)bytesToAvaiUnit:(long long int)bytes{
    if(bytes < 1024)   { // B
        
        return [NSString stringWithFormat:@"%lldB", bytes];
        
    }
    
    else if(bytes >= 1024 && bytes < 1024 * 1024) { // KB
        
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
        
    }
    
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)  { // MB
        
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
        
    }
    
    else {// GB
        
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
        
    }
}

@end
