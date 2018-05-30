//
//  Macros.h
//  NFYY
//  常用宏定义
//  Created by Kingsley on 15/7/30.
//  Copyright (c) 2015年 Character Information. All rights reserved.
//

//公共常用类及方法
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//iPhone X的适配
#define  LL_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// Status bar height.
#define  LL_Status_Height      (LL_iPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define  LL_NavigationBarHeight  44.f

// Tabbar height.
#define  LL_Bottm_Bar_Height        (LL_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  LL_NavAndStatus_HEIGHT  (LL_iPhoneX ? 88.f : 64.f)

#define LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HEIGHT_STATUS_BAR 20    //状态栏高度
#define HEIGHT_NAVIGATION_BAR 44        //导航栏高度
#define HEIGHT_TAB_BAR  49      //Tab高度
#define HEIGHT_TABLE_CELL_DEFAULT  44      //TableViewCell默认高度

#define HEIGHT_VIEW_INSIDE_NAV SCREEN_HEIGHT - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR
#define HEIGHT_VIEW_INSIDE_NAV_TAB SCREEN_HEIGHT - HEIGHT_STATUS_BAR - HEIGHT_NAVIGATION_BAR - HEIGHT_TAB_BAR

#define EncodeFormDic(dic,key) [dic[key] isKindOfClass:[NSString class]] ? dic[key] :([dic[key] isKindOfClass:[NSNumber class]] ? [dic[key] stringValue]:@"")

//判断IOS版本
#define IS_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0 ? YES : NO)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0 ? YES : NO)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 ? YES : NO)
#define IS_IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ? YES : NO)

//偏移视图
#define REPLACE_VIEW(y) self.view.bounds = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height)

//快速调试
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif
