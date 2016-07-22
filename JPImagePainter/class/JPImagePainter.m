//
//  JPImagePainter.m
//  JPImagePainter
//
//  Created by ovopark_iOS on 16/7/21.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "JPImagePainter.h"
#import "JPImagePainterView.h"

@interface JPImagePainter () <JPImagePainterViewDelegate>
{
    JPImagePainterView *painterView;
}

@end

@implementation JPImagePainter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    painterView = [[JPImagePainterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) originalImage:self.originalImage andViewType:(self.navigationController.navigationBar ? JPImagePainterViewTypePush : JPImagePainterViewTypePresent)];
    painterView.title = self.painterTitle;
    painterView.delegate = self;
    [self.view addSubview:painterView];
    
    
    //注册通知监测横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.navigationBar) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

#pragma mark - 收到横竖屏切换通知的方法
- (void)deviceOrientationDidChange:(NSNotification *)sender
{
    painterView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - JPImagePainterViewDelegate
- (void)imagePainterViewCancelButtonClicked:(JPImagePainterView *)imagePainterView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePainterDidClickCancelButton:)]) {
        [self.delegate imagePainterDidClickCancelButton:self];
    }
}
- (void)imagePainterView:(JPImagePainterView *)imagePainterView saveButtonClicked:(UIImage *)paintedImage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePainter:saveButtonClicked:)]) {
        [self.delegate imagePainter:self saveButtonClicked:paintedImage];
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
