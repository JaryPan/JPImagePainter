//
//  ViewController.m
//  JPImagePainter
//
//  Created by ovopark_iOS on 16/7/21.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "ViewController.h"
#import "JPImagePainter.h"

@interface ViewController () <JPImagePainterDelegate>
{
    UIImageView *imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width * 9/16)];
    imageView.image = [UIImage imageNamed:@"examplePicture.jpg"];
    [self.view addSubview:imageView];
    
    UIButton *NAVBut = [UIButton buttonWithType:UIButtonTypeCustom];
    NAVBut.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, self.view.frame.size.width, 40);
    [NAVBut setTitle:@"push" forState:UIControlStateNormal];
    [NAVBut addTarget:self action:@selector(NAVButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NAVBut];
    
    UIButton *NotNAVBut = [UIButton buttonWithType:UIButtonTypeCustom];
    NotNAVBut.frame = CGRectMake(0, CGRectGetMaxY(NAVBut.frame) + 10, self.view.frame.size.width, 40);
    [NotNAVBut setTitle:@"present" forState:UIControlStateNormal];
    [NotNAVBut addTarget:self action:@selector(NotNAVButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NotNAVBut];
}

- (void)NAVButAction:(UIButton *)sender
{
    JPImagePainter *painter = [[JPImagePainter alloc] init];
    painter.painterTitle = @"涂鸦";
    painter.originalImage = imageView.image;
    painter.delegate = self;
    [self.navigationController pushViewController:painter animated:YES];
}

- (void)NotNAVButAction:(UIButton *)sender
{
    JPImagePainter *painter = [[JPImagePainter alloc] init];
    painter.painterTitle = @"涂鸦";
    painter.originalImage = imageView.image;
    painter.delegate = self;
    [self presentViewController:painter animated:YES completion:nil];
}

#pragma mark - JPImagePainterDelegate
- (void)imagePainterDidClickCancelButton:(JPImagePainter *)imagePainter
{
    if (imagePainter.navigationController.navigationBar) {
        [imagePainter.navigationController popViewControllerAnimated:YES];
    } else {
        [imagePainter dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)imagePainter:(JPImagePainter *)imagePainter saveButtonClicked:(UIImage *)paintedImage
{
    imageView.image = paintedImage;
    
    if (imagePainter.navigationController.navigationBar) {
        [imagePainter.navigationController popViewControllerAnimated:YES];
    } else {
        [imagePainter dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
