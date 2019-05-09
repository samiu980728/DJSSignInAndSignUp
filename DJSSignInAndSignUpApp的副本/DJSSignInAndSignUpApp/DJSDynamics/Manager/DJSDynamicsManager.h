//
//  DJSDynamicsManager.h
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/5/7.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DJSUserModel.h"

typedef void(^DJSTransportImagToSeverHandle)(NSString * imageNameStr);

typedef void(^DJSDownLoadImageWithImageNameHandle)(NSString * imageNameStr);

typedef void(^DJSRefleshUserMessageHandle)(DJSUserModel * userModel);

typedef void(^ErrorHandle)(NSError * error);

@interface DJSDynamicsManager : NSObject

+(instancetype)sharedManager;

//导入网络请求
///上传图片至后台
- (void)fetchImgToSeverWithImage:(UIImage *)img andTokenStr:(NSString *)tokenStr Succeed:(DJSTransportImagToSeverHandle)succeedBlock error:(ErrorHandle)errorBlock;

//下载图片至手机
- (void)fetchImgToiPhoneWithImageName:(NSString *)imageNameStr Succeed:(DJSDownLoadImageWithImageNameHandle)succeedBlock error:(ErrorHandle)errorBlock;
@end
