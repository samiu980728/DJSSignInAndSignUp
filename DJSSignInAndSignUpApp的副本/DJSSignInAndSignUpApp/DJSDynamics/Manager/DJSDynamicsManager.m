//
//  DJSDynamicsManager.m
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/5/7.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSDynamicsManager.h"
#import <AFNetworking.h>

@implementation DJSDynamicsManager

static DJSDynamicsManager * dynamicManager;

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dynamicManager = [[self alloc] init];
    });
    return dynamicManager;
}

- (void)fetchImgToSeverWithImage:(UIImage *)img andTokenStr:(NSString *)tokenStr Succeed:(DJSTransportImagToSeverHandle)succeedBlock error:(ErrorHandle)errorBlock
{
    NSData *imageData;
    NSString *mimetype;
    //判断下图片是什么格式
    if (UIImagePNGRepresentation(img) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(img);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(img, 1.0);
    }
    
    //获得系统中选定照片的名称
    
    NSString *urlString = @"http://47.102.206.19:8080/user/upload.do";
    NSDictionary *params = @{@"upload_file":@"708c3f48-cb6c-448d-8909-253665ab17b0.png"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __block NSString * imageNameStr;
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    //相册中选中的图片先保存到一个文件中 然后再从这个文件中调用
#pragma mark : Reqeust 将照片地址保存在文件中
    //获取caches目录路径的方法
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachesStr = [paths objectAtIndex:0];
    
    //往caches中存入数据
    NSString * imageStr = @"708c3f48-cb6c-448d-8909-253665ab17b0.png";
    NSString * filePath = [cachesStr stringByAppendingPathComponent:@"text.txt"];
    if ([imageStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        NSLog(@"存入成功");
    }
    
    NSLog(@"%@",[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]);
    
    //所以请求体是文件类型
    NSData * paramData = [[NSData alloc] initWithContentsOfFile:[self paramStringFromParams:params]];
    
    //添加一种支持格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil,nil];
    [manager POST:urlString parameters:paramData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
#pragma mark attention z这里面是POST请求 具体要做到事
        NSString *str = @"upload_file";
        NSString *fileName = [[NSString alloc] init];
        if (UIImagePNGRepresentation(img) != nil) {
            fileName = [NSString stringWithFormat:@"%@.png", str];
        } else{
            fileName = [NSString stringWithFormat:@"%@.png", str];
        }
        // 上传图片，以文件流的格式
        /**
         *filedata : 图片的data
         *name     : 后台的提供的字段
         *mimeType : 类型
         */
        [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:mimetype];
    } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //打印看下返回的是什么东西
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        imageNameStr = [[dic objectForKey:@"data"] objectForKey:@"url"];
        //[self downLoadImageWithImageName:imageNameStr];
        
        //UIButton加载网络图片
//        if (self.submitCallBackBlock) {
//            self.submitCallBackBlock(imageNameStr);
//        }
        NSLog(@"dic = %@",dic);
        succeedBlock(imageNameStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败，失败原因是:%@", error);
        errorBlock(error);
    }];
}

- (void)downLoadImageWithImageName:(NSString *)imageNameStr
{
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL * url = [NSURL URLWithString:imageNameStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL * documentsDirectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //给出下载到电脑上的具体地址
        NSLog(@"File download to: %@",filePath);
    }];
    [downloadTask resume];
}

- (NSString *)paramStringFromParams:(NSDictionary *)params
{
    NSMutableString * returnValueStr = [[NSMutableString alloc] initWithCapacity:0];
    NSArray * paramsAllKeys = [params allKeys];
    for (int i = 0; i < paramsAllKeys.count; i++) {
        [returnValueStr appendFormat:@"%@=%@",[paramsAllKeys objectAtIndex:i],[self encodeURIComponent:[params objectForKey:[paramsAllKeys objectAtIndex:i]]]];
        if (i < paramsAllKeys.count && paramsAllKeys.count > 1) {
            [returnValueStr appendString:@"&"];
        }
    }
    return returnValueStr;
}

-(NSString*)encodeURIComponent:(NSString*)str
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}


@end

