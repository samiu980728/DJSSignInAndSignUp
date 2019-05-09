//
//  ViewController.h
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/3/17.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, copy) void(^submitCallBackBlock)(NSString * tokenIdStr);

@end

