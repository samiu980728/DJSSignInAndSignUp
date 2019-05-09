//
//  DJSForgetPassWordViewController.m
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/3/25.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSForgetPassWordViewController.h"

@interface DJSForgetPassWordViewController ()

@property (nonatomic, strong) UIButton * getMsgCodeButton;

@property (nonatomic, strong) UITextField * phoneNumberTextField;

@property (nonatomic, strong) UITextField * msgCodeTextField;

@property (nonatomic, strong) UITextField * passWordTextField;

@property (nonatomic, strong) UITextField * repectPassWordTextField;

@property (nonatomic, strong) UIButton * getNewPassWordBUtton;

@end

@implementation DJSForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"忘记密码";
    
    self.getMsgCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getMsgCodeButton.frame = CGRectMake(0, 100, 100, 30);
    self.getMsgCodeButton.backgroundColor = [UIColor blackColor];
    [self.getMsgCodeButton setTitle:@"点击发送验证码" forState:UIControlStateNormal];
    [self.getMsgCodeButton addTarget:self action:@selector(pressGetMsgButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getMsgCodeButton];
    
    self.phoneNumberTextField = [[UITextField alloc] init];
    self.phoneNumberTextField.frame = CGRectMake(100, 100, 300, 30);
    self.phoneNumberTextField.placeholder = @"请输入您的电话号码";
    [self.view addSubview:self.phoneNumberTextField];
    
    self.msgCodeTextField = [[UITextField alloc] init];
    self.msgCodeTextField.frame = CGRectMake(100, 150, 300, 30);
    self.msgCodeTextField.placeholder = @"请输入您的验证码";
    [self.view addSubview:self.msgCodeTextField];
    
    self.passWordTextField = [[UITextField alloc] init];
    self.passWordTextField.frame = CGRectMake(100, 200, 300, 30);
    self.passWordTextField.placeholder = @"请输入您的新密码";
    [self.view addSubview:self.passWordTextField];
    
    self.repectPassWordTextField = [[UITextField alloc] init];
    self.repectPassWordTextField.frame = CGRectMake(100, 250, 300, 30);
    self.repectPassWordTextField.placeholder = @"请重复输入您的新密码";
    [self.view addSubview:self.repectPassWordTextField];
    
    self.getNewPassWordBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getNewPassWordBUtton.frame = CGRectMake(150, 300, 250, 30);
    self.getNewPassWordBUtton.backgroundColor = [UIColor blackColor];
    [self.getNewPassWordBUtton setTitle:@"修改密码" forState:UIControlStateNormal];
    [self.getNewPassWordBUtton addTarget:self action:@selector(pressChangePassWordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getNewPassWordBUtton];
}

- (void)pressGetMsgButton:(UIButton *)getMsgBUtton
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.102.206.19:8080/user/get_msgcode.do"]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.timeoutInterval = 5.0;
    urlRequest.HTTPMethod = @"POST";
    urlRequest.allHTTPHeaderFields = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    urlRequest.HTTPBody = [[self paramStringFromParams:[NSDictionary dictionaryWithObject:self.phoneNumberTextField.text forKey:@"phoneNumber"]] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * phoneHttpDict = [NSDictionary dictionaryWithObject:self.phoneNumberTextField.text forKey:@"phoneNumber"];
    NSLog(@"phoneHttpDict = %@",phoneHttpDict);
    //    urlRequest.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"HTTPBody = %@",urlRequest.HTTPBody);
    NSURLSession * session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dataDic = %@",dataDic);
        NSLog(@"111");
    }] resume];
}

- (void)pressChangePassWordButton:(UIButton *)changButton
{
    NSString * phoneStr = [NSString stringWithFormat:@"%@",self.phoneNumberTextField.text];
    NSString * msgCodeStr = [NSString stringWithFormat:@"%@",self.msgCodeTextField.text];
    NSString * passWordStr = [NSString stringWithFormat:@"%@",self.repectPassWordTextField.text];
    NSURL * url = [NSURL URLWithString:@"http://47.102.206.19:8080/user/forget_reset_password.do"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSDictionary * bodtDict = [[NSDictionary alloc] initWithObjects:@[phoneStr,msgCodeStr,passWordStr] forKeys:@[@"phoneNumber",@"msgCode",@"password"]];
    urlRequest.HTTPBody = [[self paramStringFromParams:bodtDict] dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.timeoutInterval = 5.0;
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSession * session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict = %@",dict);
    }] resume];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
