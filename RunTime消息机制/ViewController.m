//
//  ViewController.m
//  RunTime消息机制
//
//  Created by Lix on 16/3/3.
//  Copyright © 2016年 Lix. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    //测试doSomething方法的寻找顺序
    [self performSelector:@selector(doSomething)];
    
    [self performSelector:@selector(secondVCMethod)];
    
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    Class class = NSClassFromString(@"SecondViewController");
    
    UIViewController * vc = class.new;
    if (aSelector == NSSelectorFromString(@"secondVCMethod")) {
        NSLog(@"secondVC do this !");
        
        return vc;
    }
    return nil;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(doSomething)) {
        NSLog(@"add Method here");
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}


 void dynamicMethodIMP(id self, SEL _cmd)
{
    NSLog(@"doSomething SEL");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
