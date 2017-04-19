//
//  NewLoginVC.m
//  Snuzo App
//
//  Created by Oneclick on 3/27/17.
//  Copyright © 2017 Oneclick IT. All rights reserved.
//

#import "NewLoginVC.h"
#import "Constant.h"
@interface NewLoginVC ()

@end

@implementation NewLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.image=[UIImage imageNamed:@"bg-ip-5"];
    [self.view addSubview:bg];
    
    UIView * backView = [[UIView alloc] init];
    backView.frame = self.view.frame;
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    
    UIImageView * logoImg =[[UIImageView alloc] init];
    logoImg.frame=CGRectMake(85, 15, 150, 49);
    if (IS_IPHONE_4)
    {
        bg.image=[UIImage imageNamed:@"bg-ip-4"];
    }
    else if (IS_IPHONE_6)
    {
        logoImg.frame=CGRectMake(112.5, 20, 150, 49);
    }
    else if (IS_IPHONE_6plus)
    {
        logoImg.frame=CGRectMake(132, 20, 150, 49);
    }
    logoImg.image=[UIImage imageNamed:@"nursingLogo.png"];
    [self.view addSubview:logoImg];

    self.view.backgroundColor =[UIColor redColor];
    // Do any additional setup after loading the view.
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
