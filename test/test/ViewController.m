//
//  ViewController.m
//  test
//
//  Created by hesslergao on 2016/12/1.
//  Copyright © 2016年 hesslergao. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"

#define MacroStringFromClass(class) (@""#class)
#define loopcout 1000000
#define loopLessCount   1000000

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn3F;
@property (weak, nonatomic) IBOutlet UITableView *tableView2F;
@property (weak, nonatomic) IBOutlet UIStackView *stackView1F;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew1F;
@property (weak, nonatomic) IBOutlet UIButton *btn6F;

@end

@implementation ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    titleButton.tintColor = [UIColor whiteColor];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    titleButton.titleLabel.text = @"未处理(4)";
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    titleButton.frame = titleView.bounds;
    [titleView addSubview:titleButton];
    
    self.navigationItem.titleView = titleView;
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self loopForMacro];
//    [self loopForString];
//    [self loopForNSStringFromClass];
//    [self loopForMacro];
//    [self loopForString];
//    [self loopForNSStringFromClass];
//    [self loopForMacro];
//    [self loopForString];
//    [self loopForNSStringFromClass];
//    [self loopForExchangeClass];
    
//    [self loopForFindViewController:self.btn3F];
//    [self loopForFindViewController:self.tableView2F];
//    [self loopForFindViewController:self.stackView1F];
//    [self loopForFindViewController:self.imageVIew1F];
//    [self loopForFindViewController:self.btn6F];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView2F animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"输入内容过长";
    [hud hide:YES afterDelay:0.8];
    
    [self.tableView2F removeFromSuperview];
    self.tableView2F = nil;
//    [self performSelector:@selector(removeTableView2F) withObject:nil afterDelay:0.2];

}

-(void)removeTableView2F
{
    [self.tableView2F removeFromSuperview];
    self.tableView2F = nil;
}

- (void)loopForMacro{
    NSDate *startDate = [NSDate date];
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < loopcout; i++) {
        [str appendString:MacroStringFromClass(ViewController)];
    }
    NSTimeInterval cost = [[NSDate date]timeIntervalSinceDate:startDate];
    NSLog(@"loopForMacro cost:%f",cost);
}

- (void)loopForString{
    NSDate *startDate = [NSDate date];
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < loopcout; i++) {
        [str appendString:@"ViewController"];
    }
    NSTimeInterval cost = [[NSDate date]timeIntervalSinceDate:startDate];
    NSLog(@"loopForString cost:%f",cost);
}

- (void)loopForNSStringFromClass{
    NSDate *startDate = [NSDate date];
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < loopcout; i++) {
        [str appendString:NSStringFromClass([ViewController class])];
    }
    NSTimeInterval cost = [[NSDate date]timeIntervalSinceDate:startDate];
    NSLog(@"loopForNSStringFromClass cost:%f",cost);
}

- (void)loopForExchangeClass
{
    NSDate *startDate = [NSDate date];
    for (int i = 0; i < loopLessCount; i++) {
        [ViewController exchangeClass:[self class] Method:@selector(viewWillAppear:) withNewMethod:@selector(testViewWillAppear:)];
    }
    NSTimeInterval cost = [[NSDate date]timeIntervalSinceDate:startDate];
    NSLog(@"loopForExchangeClass cost:%f",cost);
}

- (void)loopForFindViewController:(UIView*)view
{
    NSDate *startDate = [NSDate date];
    for (int i = 0; i < loopLessCount; i++) {
        [self findViewController:view];
    }
    NSTimeInterval cost = [[NSDate date]timeIntervalSinceDate:startDate];
    NSLog(@"findViewControll: %@ cost:%f", view.restorationIdentifier, cost);
}

-(void)testViewWillAppear:(BOOL)animated
{
    [self testViewWillAppear:animated];
}

+(void)exchangeClass:(Class)class Method:(SEL)origSel withNewMethod:(SEL)newSel
{
    Method origMethod = class_getInstanceMethod(class, origSel);
    if (!origMethod){
        origMethod = class_getClassMethod(class, origSel);
    }
    if (!origMethod)
        @throw [NSException exceptionWithName:@"Original method not found" reason:nil userInfo:nil];
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!newMethod){
        newMethod = class_getClassMethod(class, newSel);
    }
    if (!newMethod)
        @throw [NSException exceptionWithName:@"New method not found" reason:nil userInfo:nil];
    if (origMethod==newMethod)
        @throw [NSException exceptionWithName:@"Methods are the same" reason:nil userInfo:nil];
    method_exchangeImplementations(origMethod, newMethod);
}


- (UIViewController*)findViewController:(UIView*)testView {
    for (UIView* next = [testView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
