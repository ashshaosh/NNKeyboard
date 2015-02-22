//
//  ViewController.m
//  NNKeyboard Demo
//
//  Created by Danny Holmes.
//  Copyright (c) 2015 Danny Holmes, notnatural.co.
//

/*
The MIT License (MIT)

Copyright (c) 2015 Danny Holmes, notnatural.co.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#import "ViewController.h"
#import "NNKeyboard.h"
#import "UIColor+MLPFlatColors.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NNKeyboard *keyboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height;
    
    NNKeyboard *kb1 = [[NNKeyboard alloc] initWithFrame:CGRectMake(width*.15, height*.1, width*.7, height*.15)];
    [kb1 addTarget:self action:@selector(handleKB:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:kb1];
    
    NNKeyboard *kb = [[NNKeyboard alloc] initWithFrame:CGRectMake(width*.01, height*.28, width*.48, height*.15)];
    [kb addTarget:self action:@selector(handleKB:) forControlEvents:UIControlEventValueChanged];
    kb.visibleKeys = 8;
    kb.octaves = 2;
    kb.lowestOctave = 3;
    kb.borderSize = 6;
    kb.roundess = 10;
    kb.color = [UIColor flatDarkGrayColor];
    [self.view addSubview:kb];
    
    NNKeyboard *kb0 = [[NNKeyboard alloc] initWithFrame:CGRectMake(width*.51, height*.32, width*.48, height*.08)];
    [kb0 addTarget:self action:@selector(handleKB:) forControlEvents:UIControlEventValueChanged];
    kb0.visibleKeys = 6;
    kb0.octaves = 5;
    kb0.lowestOctave = 2;
    kb0.borderSize = 6;
    kb0.roundess = 18;
    kb0.hidesNumbers = YES;
    kb0.color = [UIColor flatDarkRedColor];
    [self.view addSubview:kb0];
    
    self.keyboard = [[NNKeyboard alloc] initWithFrame:CGRectMake(width*.15, height*.46, width*.7, height*.15)];
    [self.keyboard addTarget:self action:@selector(handleKB:) forControlEvents:UIControlEventValueChanged];
    self.keyboard.visibleKeys = 12;
    self.keyboard.octaves = 12;
    self.keyboard.borderSize = 12;
    self.keyboard.roundess = 50;
    self.keyboard.hidesNumbers = YES;
    self.keyboard.color = [UIColor flatDarkBlueColor];
    self.keyboard.startupAnimationDuration = 4;
    [self.view addSubview:self.keyboard];
    
    NNKeyboard *kb3 = [[NNKeyboard alloc] initWithFrame:CGRectMake(width*.01, height*.75, width*.98, height*.24)];
    [kb3 addTarget:self action:@selector(handleKB:) forControlEvents:UIControlEventValueChanged];
    kb3.shouldDoCoolAnimation = NO;
    kb3.lowestOctave = 1;
    [self.view addSubview:kb3];
    
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, height*.63, width, height*.1)];
    _label.text = [NSString stringWithFormat:@"NNKeyboard Demo"];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:24];
    [self.view addSubview:_label];
}

- (void)handleKB:(NNKeyboard *)sender {
    NSLog(@"MIDI: %.0f",sender.value);
    
    _label.text = [NSString stringWithFormat:@"MIDI: %.0f",sender.value];
    //[sender scrollTo:.5];
}

@end
