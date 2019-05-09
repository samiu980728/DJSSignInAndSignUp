//
//  DJSDynamicsViewController.h
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/4/23.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface DJSDynamicsViewController : UIViewController

@property (nonatomic, copy) void(^submitCallBackBlock)(NSString * imageNameStr);

@property (nonatomic, copy) NSString * tokenStr;

@end
