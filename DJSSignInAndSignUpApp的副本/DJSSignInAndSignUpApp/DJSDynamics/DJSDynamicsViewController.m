//
//  DJSDynamicsViewController.m
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/4/23.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSDynamicsViewController.h"
#import <Masonry.h>
#import <Photos/Photos.h>
#import <AFNetworking.h>
#import "ViewController.h"
#import <sdwebimage/UIButton+WebCache.h>
#import "DJSDynamicsManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface DJSDynamicsViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation DJSDynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(pressImageButton:) forControlEvents:UIControlEventTouchUpInside];
    imageButton.layer.cornerRadius = 25;
    imageButton.layer.masksToBounds = YES;
    [self.view addSubview:imageButton];
    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    self.submitCallBackBlock = ^(NSString *imageNameStr) {
        [imageButton sd_setImageWithURL:[NSURL URLWithString:imageNameStr] forState:UIControlStateNormal];
    };
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    UITapGestureRecognizer * changUserIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserIconAction:)];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:changUserIconTap];
    
    //这个按钮起作用
    [imageButton addGestureRecognizer:changUserIconTap];
}

//更换头像
- (void)changeUserIconAction:(UITapGestureRecognizer *)tap
{
    UIAlertController * userActionController = [UIAlertController alertControllerWithTitle:@"请选择上传类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否来自图片库
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [userActionController addAction:alertAction];
    [userActionController addAction:photoAction];
    [userActionController addAction:cancelAction];
    [self presentViewController:userActionController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获得所选择的图片
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    _imageView.image = image;
    //获得系统中选定照片的名称
    NSURL *imageUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    //根据url获取asset信息, 并通过block进行回调
//    [assetsLibrary assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
//        ALAssetRepresentation *representation = [asset defaultRepresentation];
//        NSString *imageName = representation.filename;
//        NSLog(@"imageName:%@", imageName);
//    } failureBlock:^(NSError *error) {
//        NSLog(@"%@", [error localizedDescription]);
//    }];
    
    
    //对选取的图片进行大小上的压缩
    UIImage * compressImg = [self imageWithImageSimple:image scaledToSize:CGSizeMake(60, 60)];
    //将裁剪后的图片上传至服务器
#pragma mark Request 另一种方法上传服务器至后台
    DJSDynamicsManager * dynamicsManager = [DJSDynamicsManager sharedManager];
    [dynamicsManager fetchImgToSeverWithImage:compressImg andTokenStr:_tokenStr Succeed:^(NSString *imageNameStr) {
        if (self.submitCallBackBlock) {
            self.submitCallBackBlock(imageNameStr);
        }
    } error:^(NSError *error) {
        NSLog(@"请求服务器失败。原因：%@",error);
    }];
    
//    [self transportImgToServerWithImg:compressImg];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片方法
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//利用manager上传服务器至后台

//上传图片至服务器后台
- (void)transportImgToServerWithImg:(UIImage *)img{
//    img.imna
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
    NSString *urlString = @"http://47.102.206.19:8080/user/upload.do";
    NSDictionary *params = @{@"upload_file":@"708c3f48-cb6c-448d-8909-253665ab17b0.png"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
#pragma mark 错误！！！block用法
    __block NSString * imageNameStr;
    __block NSString * tokenID;
    tokenID = [[NSString alloc] init];
    ViewController * viewController = [[ViewController alloc] init];
    viewController.submitCallBackBlock = ^(NSString *tokenIdStr) {
        tokenID = tokenIdStr;
    };
    [manager.requestSerializer setValue:_tokenStr forHTTPHeaderField:@"token"];
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
        [self downLoadImageWithImageName:imageNameStr];
        //UIButton加载网络图片
        if (self.submitCallBackBlock) {
            self.submitCallBackBlock(imageNameStr);
        }
        NSLog(@"dic = %@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败，失败原因是:%@", error);
    }];
}
- (void)upLoadImageWithImageName:(NSString *)imageNameStr toButton:(UIButton *)button
{
    [button sd_setImageWithURL:[NSURL URLWithString:imageNameStr] forState:UIControlStateNormal];
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

-(NSString*)encodeURIComponent:(NSString*)str{
    
        return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
}

- (void)pressImageButton:(UIButton *)btn
{
    
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
