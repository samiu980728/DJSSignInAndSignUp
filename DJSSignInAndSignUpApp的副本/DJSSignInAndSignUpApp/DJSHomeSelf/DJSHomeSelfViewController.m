//
//  DJSHomeSelfViewController.m
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/4/22.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSHomeSelfViewController.h"
#import <Masonry.h>
#import "DJSHomeSelfTableViewCell.h"
#import "DJSDynamicsViewController.h"

@interface DJSHomeSelfViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * homeSelfTableView;

@property (nonatomic, strong) DJSHomeSelfTableViewCell * homeSelfTalbeViewCell;

@property (nonatomic, strong) NSMutableArray * messageNameArray;

@property (nonatomic, copy) NSArray * imageArray;

@end

@implementation DJSHomeSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageNameArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"收藏的单词",@"收藏的美文",@"收藏的句子",@"设置", nil]];
    self.imageArray = [NSArray arrayWithObjects:@"yinzhang.png",@"jilu.png",@"xin.png",@"shezhi.png", nil];
    
    self.homeSelfTableView = [[UITableView alloc] init];
    [self.view addSubview:self.homeSelfTableView];
    self.homeSelfTableView.delegate = self;
    self.homeSelfTableView.dataSource = self;
    self.homeSelfTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.homeSelfTableView registerClass:[DJSHomeSelfTableViewCell class] forCellReuseIdentifier:@"messageCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DJSDynamicsViewController * dynamicViewController = [[DJSDynamicsViewController alloc] init];
        dynamicViewController.tokenStr = self.tokenS;
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:dynamicViewController];
        [self.navigationController pushViewController:dynamicViewController animated:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    } else {
    return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCell"];
    DJSHomeSelfTableViewCell * selfTableViewCell = [[DJSHomeSelfTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    if (indexPath.row == 0) {
        if (!cell1) {
            cell1 = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
        }
        cell1.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 25;
        imageView.backgroundColor = [UIColor darkGrayColor];
        [cell1.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell1.mas_left).offset(50);
            make.centerY.mas_equalTo(cell1);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        
        UILabel * nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"您还没有设置昵称";
        nameLabel.font = [UIFont systemFontOfSize:22];
        [cell1.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(40);
            make.centerY.mas_equalTo(cell1);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(200);
        }];
        
        return cell1;
    } else {
        selfTableViewCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        selfTableViewCell.nameLabel.text = self.messageNameArray[indexPath.row-1];
        selfTableViewCell.cuteCellImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row-1]];
        return selfTableViewCell;
    }
    
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
