//
//  ViewController.m
//  EditImage
//
//  Created by HouHoward on 2017/2/14.
//  Copyright © 2017年 rongzi. All rights reserved.
//

#import "ViewController.h"
#import "DDPaintView.h"

@interface ViewController ()
- (IBAction)clear;
- (IBAction)back;
- (IBAction)save;

@property (weak, nonatomic) IBOutlet DDPaintView *paintView;
@property (weak, nonatomic) IBOutlet UIImageView *originalView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"FullSizeRender.jpg"];
    self.originalView.image = image;
    
    [self adjustImageViewSize: image.size];
}

- (void) adjustImageViewSize:(CGSize) imageSize{
    
    CGSize contentSize = self.originalView.frame.size;
    
    CGFloat contentHeight = imageSize.height * (contentSize.width / imageSize.width);
    
    self.originalView.frame = CGRectMake(0, (self.contentView.frame.size.height - contentHeight) / 2, contentSize.width, contentHeight);
    
    self.paintView.frame = self.originalView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clear {
    [self.paintView clear];
}

- (IBAction)back {
    [self.paintView back];
}

- (IBAction)save {
    
    CGFloat scale =  [UIScreen mainScreen].scale;
    
    CGSize imageSize = self.originalView.image.size;
    CGSize designSize = CGSizeMake( imageSize.width/scale, imageSize.height/scale);
    
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(designSize, NO, 0.0);
    
    CGRect originalRect = self.originalView.bounds;
    
    self.originalView.bounds = CGRectMake(0, 0, designSize.width, designSize.height);
    self.paintView.bounds = self.originalView.bounds;
    
    // 2.将控制器view的layer渲染到上下文
    [self.originalView.layer renderInContext:UIGraphicsGetCurrentContext()];
    [self.paintView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 3.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束上下文
    UIGraphicsEndImageContext();
    
    // 2.保存到图片
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    NSLog(@"%@", NSHomeDirectory());
    
    self.originalView.bounds = originalRect;
    self.paintView.bounds = self.originalView.bounds;
}

/**
 保存图片操作之后就会调用
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) { // 保存失败
        NSLog(@"保存失败");
    } else { // 保存成功
        NSLog(@"保存成功");
    }
}

@end
