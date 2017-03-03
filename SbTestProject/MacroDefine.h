//
//  MacroDefine.h
//  SmartPiano
//
//  Created by Ydtec on 16/3/19.
//  Copyright © 2016年 Ydtec. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#define NotesWidth 29.883331


#define CHATROOMIDAndGROUP @"CHATROOMIDAndGROUP"

#define RCIMUserId @"RCIMUserId"

#define memberType @"membertype"

//----------方法简写-------
#define mAppDelegate        ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

//----------本地缓存文件路径-----
#define kResourceCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define kResourceTempPath NSTemporaryDirectory()

//----------页面设计相关-------
#define mStatusBarHeight      20
#define mNavBarHeight         44
#define mTabBarHeight         49
#define mScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight         ([UIScreen mainScreen].bounds.size.height)

#define sX                    self.view.frame.origin.x
#define sY                    self.view.frame.origin.y
#define sWidth                self.view.frame.size.width
#define sHeight               self.view.frame.size.height
#define mScale                [UIScreen mainScreen].scale

//加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]

//度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian*180.0) / (M_PI)

//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//G－C－D
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)

//是否为空
#define mIsNull(field) (!field || [field isEqual:[NSNull null]] || [field isEqualToString:@"(null)"] || [field isEqualToString:@""])

//----------设备系统相关---------
#define mRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiP5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiP6    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiP6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2208),[[UIScreen mainScreen] currentMode].size))||(CGSizeEqualToSize(CGSizeMake(1125, 2001),[[UIScreen mainScreen] currentMode].size)) : NO)
#define mIsiPad    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048),[[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiPadmini    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024),[[UIScreen mainScreen] currentMode].size) : NO)
#define mIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mIsiphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define mSystemVersion   ([[[UIDevice currentDevice] systemVersion] floatValue])
#define mCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define mAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define mAPPbuild        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define mAppFullVersion  [NSString stringWithFormat:@"%@.%@",mAPPVersion,mAPPbuild]

#define notFirstLaunch   mAPPVersion
#define mFirstLaunch     [mUserDefaults boolForKey:@"firstLaunch"]  //以系统版本来判断是否是第一次启动，包括升级后启动。
#define mFirstRun        [mUserDefaults boolForKey:@"firstRun"]     //判断是否为第一次运行，升级后启动不算是第一次运行
#define mIsLogin         [mUserDefaults boolForKey:@"isLogin"]      //是否登录

#define IsTeacher  ([mUserDefaults boolForKey:@"IsTeacher"] && [YDUserInfo sharedYDUserInfo].controlStudents )     //是否是老师

#define mIsJustPlay         ([YDUserInfo sharedYDUserInfo].isJustTryPlay == YES)
#define mIsBeControlByTeacher         ([YDUserInfo sharedYDUserInfo].beControlByTeacher == YES)
//[mUserDefaults boolForKey:@"IsJustPlay"]      //是否试玩

#define mRudinDown @"rudindown"         //是否下册
#define mUserName @"username"           //用户名
#define mPassword @"password"           //密码
#define mRealname @"realname"           //真实姓名
#define mUserId @"userId"               //用户id
#define mSchoolId @"schoolId"           //学校id
#define mStudents @"Students"           //被点名的学生
#define mLoginName @"loginName"         //后端用户名 (获取班级信息)
#define mSex @"sex"                     //性别
#define mClassId @"classes_id"          //班级id
#define loginToken @"token"          //登入token
#define mBuletoothName @"mBuletoothname" //连接蓝牙的名称
#define mBuletoothidentifier @"mBuletoothidentifier" //连接蓝牙的identifier
#define mIsReCreate      [mUserDefaults boolForKey:@"isReCreate"]   //是否需要重新创建tabview

#define mleftred @"leftred"   //左手rbg red
#define mleftgreen @"leftgreen"   //左手rbg green
#define mleftblue @"leftblue"   //左手rbg blue

#define mrightred @"rightred"   //右手rbg red
#define mrightgreen @"rightgreen"   //右手rbg green
#define mrightblue @"rightblue"   //右手rbg blue

#define IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//--------调试相关-------

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define mSafeRelease(object)     [object release];  x=nil
#endif

//调试模式下输入NSLog，发布后不再输入。
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod(fmt, ...) NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define debugLog(...) NSLog(__VA_ARGS__)
//#define debugMethod(fmt, ...) NSLog((@"In %s,%s [Line %d] " fmt), __PRETTY_FUNCTION__,__FILE__,__LINE__,##__VA_ARGS__)

#else
#define NSLog(...) NSLog(__VA_ARGS__)
#define NSLogMethod(...)
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod(...)
#endif

#endif /* MacroDefine_h */
