//
//  ViewController.m
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/3/17.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "ViewController.h"
#import "DJSSignUpViewController.h"
#import "DJSChangePassWordViewController.h"
#import "DJSForgetPassWordViewController.h"
#import "DJSHomeSelfViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UILabel * passWordLabel;

@property (nonatomic, strong) UITextField * nameTextView;

@property (nonatomic, strong) UITextField * passWordTextView;

@property (nonatomic, strong) UIButton * signUpButton;

@property (nonatomic, strong) UIButton * registerAccountButton;

@property (nonatomic, strong) UIButton * forgetPassWordButton;

@property (nonatomic, strong) UIButton * changPassWordButton;

@property (nonatomic, strong) UIButton * signInButton;

@property (nonatomic, copy) NSString * tokenString;

@property (nonatomic, copy) NSString * statusString;

@property (nonatomic, assign) __block BOOL ok;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"个人账户";
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(100, 100, 100, 30);
    self.nameLabel.text = @"用户名";
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.nameLabel];
    
    self.passWordLabel = [[UILabel alloc] init];
    self.passWordLabel.frame = CGRectMake(100, 160, 100, 30);
    self.passWordLabel.font = [UIFont systemFontOfSize:20];
    self.passWordLabel.text = @"密码";
    [self.view addSubview:self.passWordLabel];
    
    self.nameTextView = [[UITextField alloc] init];
    self.nameTextView.frame = CGRectMake(210, 100, 200, 30);
    self.nameTextView.placeholder = @"请输入用户名";
    [self.view addSubview:self.nameTextView];
    
    self.passWordTextView = [[UITextField alloc] init];
    self.passWordTextView.frame = CGRectMake(210, 160, 200, 30);
    self.passWordTextView.placeholder = @"请输入密码";
    [self.view addSubview:self.passWordTextView];
    
    self.signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signInButton.frame = CGRectMake(100, 200, 100, 30);
    [self.signInButton setTitle:@"登录" forState:UIControlStateNormal];
    self.signInButton.backgroundColor = [UIColor blackColor];
//    [self.signInButton addTarget:self action:@selector(directSignUp:) forControlEvents:UIControlEventTouchUpInside];

    [self.signInButton addTarget:self action:@selector(pressSignInButtonForAFNetworking:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signInButton];
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signUpButton.frame = CGRectMake(300, 200, 100, 30);
    [self.signUpButton setTitle:@"注册" forState:UIControlStateNormal];
    self.signUpButton.backgroundColor = [UIColor blackColor];
    [self.signUpButton addTarget:self action:@selector(pressSignUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
    
    self.changPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changPassWordButton.frame = CGRectMake(100, 250, 100, 30);
    [self.changPassWordButton setTitle:@"修改密码" forState:UIControlStateNormal];
    self.changPassWordButton.backgroundColor = [UIColor blackColor];
    [self.changPassWordButton addTarget:self action:@selector(pressChangePassWordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changPassWordButton];
    
    self.forgetPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPassWordButton.frame = CGRectMake(300, 250, 100, 30);
    [self.forgetPassWordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.forgetPassWordButton.backgroundColor = [UIColor blackColor];
    [self.forgetPassWordButton addTarget:self action:@selector(pressForgetPassWordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPassWordButton];
}

- (void)pressForgetPassWordButton:(UIButton *)forgetButton
{
    DJSForgetPassWordViewController * forViewController = [[DJSForgetPassWordViewController alloc] init];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:forViewController];
    [self.navigationController pushViewController:forViewController animated:YES];
}


#pragma mark Request 测试 直接登录按钮
- (void)directSignUp:(UIButton *)button
{
    DJSHomeSelfViewController * homeSelfController = [[DJSHomeSelfViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:homeSelfController];
    [self.navigationController pushViewController:homeSelfController animated:YES];
}



//AFNetworking
- (void)pressSignInButtonForAFNetworking:(UIButton *)button
{
    NSURL * url = [NSURL URLWithString:@"http://47.102.206.19:8080/user/login.do"];
    NSString * urlStr = @"http://47.102.206.19:8080/user/login.do";
    NSString * userNameStr = [NSString stringWithFormat:@"%@",self.nameTextView.text];
    NSString * passWordStr = [NSString stringWithFormat:@"%@",self.passWordTextView.text];
    NSDictionary * userDict = [[NSDictionary alloc] initWithObjects:@[userNameStr,passWordStr] forKeys:@[@"phoneNumber",@"password"]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlStr parameters:userDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        self.statusString = responseObject[@"status"];
        self.ok = [[NSString stringWithFormat:@"%@",self.statusString] isEqualToString:@"0"];
        self.tokenString = responseObject[@"data"][@"token"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"_statusString = %@",_statusString);
        if (self.ok) {
            DJSHomeSelfViewController * homeSelfController = [[DJSHomeSelfViewController alloc] init];
            homeSelfController.tokenS = self.tokenString;
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:homeSelfController];
            //block的错误用法
            if (self.submitCallBackBlock) {
                self.submitCallBackBlock(_tokenString);
            }
            [self.navigationController pushViewController:homeSelfController animated:YES];
        }
    });
}

//NSURLSession
- (void)pressSignInButton:(UIButton *)button
{
    NSString * userNameStr = [NSString stringWithFormat:@"%@",self.nameTextView.text];
    NSString * passWordStr = [NSString stringWithFormat:@"%@",self.passWordTextView.text];
    NSURL * url = [NSURL URLWithString:@"http://47.102.206.19:8080/user/login.do"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.timeoutInterval = 5.0;
    urlRequest.HTTPMethod = @"POST";
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary * userDict = [[NSDictionary alloc] initWithObjects:@[userNameStr,passWordStr] forKeys:@[@"phoneNumber",@"password"]];
    urlRequest.HTTPBody = [[self paramStringFromParams:userDict] dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession * session = [NSURLSession sharedSession];
    __block NSString * statusStr;
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"");
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString * tokenStr = dict[@"data"][@"token"];
        statusStr = dict[@"status"];
        self.ok = [statusStr isEqualToString:@"0"];
        self.tokenString = tokenStr;
        NSLog(@"statusStr = %@",statusStr);
        NSLog(@"dict = %@",dict);
    }] resume];
    if ([statusStr isEqualToString:@"0"]) {
#pragma mark
        DJSHomeSelfViewController * homeSelfController = [[DJSHomeSelfViewController alloc] init];
     UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:homeSelfController];
        [self.navigationController pushViewController:nav animated:YES];
        
    }
}

- (NSString *)paramStringFromParams:(NSDictionary *)params
{
    NSMutableString * returnValueStr = [[NSMutableString alloc] initWithCapacity:0];
    NSArray * paramsAllKeys = [params allKeys];
    for (int i = 0; i < paramsAllKeys.count; i++) {
        [returnValueStr appendFormat:@"%@=%@",[paramsAllKeys objectAtIndex:i],[self encodeURIComponent:[params objectForKey:[paramsAllKeys objectAtIndex:i]]]];
        if (i < paramsAllKeys.count) {
            [returnValueStr appendString:@"&"];
        }
    }
    return returnValueStr;
}

-(NSString*)encodeURIComponent:(NSString*)str{
    
        return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
}

- (void)pressChangePassWordButton:(UIButton *)button
{
    DJSChangePassWordViewController * changePassWordViewController = [[DJSChangePassWordViewController alloc] init];
    
}

- (void)pressSignUpButton:(UIButton *)button
{
    DJSSignUpViewController * signUpViewCoontroller = [[DJSSignUpViewController alloc] init];
    [self presentViewController:signUpViewCoontroller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
