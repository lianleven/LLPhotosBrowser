//
//  ViewController.m
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/26.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import "ViewController.h"
#import "LLDemoController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchButton:(id)sender {
    [self.navigationController pushViewController:[LLDemoController new] animated:YES];
}


@end
