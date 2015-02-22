//
//  NNKeyboard.m
//  scrollView
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

#import "NNKeyboard.h"

@implementation NNKeyboard {
    int tag;
    NSMutableArray *allTheKeys;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    
    CGRect keyboardRect = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    
    self.octaves = 9;
    self.lowestOctave = 2;
    self.visibleKeys = keyboardRect.size.width/37.5;
    
    self.borderSize = 2;
    self.roundess = 0;
    self.color =[UIColor blackColor];
    self.hidesNumbers = NO;
    
    self.touchesForScroll = 1;
    self.touchBehavior = UIControlEventTouchUpInside;
    self.startupAnimationDuration = 3;
    self.shouldDoCoolAnimation = YES;
}

- (void)drawRect:(CGRect)rect {
    [self drawKeyboard];
}

- (void)drawKeyboard {
    BOOL animate;
    if (!keyboard) {
        animate = YES;
    } else {
        animate = NO;
    }
    
    CGRect keyboardRect = self.bounds;
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat keyboardWidth = keyboardRect.size.width;
    
    CGFloat keyboardYOrigin = keyboardRect.origin.y;
    CGFloat keyboardXOrigin = keyboardRect.origin.x;
    
    CGFloat whiteKeyWidth = keyboardWidth/self.visibleKeys;
    CGFloat blackKeyWidth = keyboardWidth*(.56/self.visibleKeys);
    CGFloat blackKeyHeight = keyboardHeight *.58;
    
    CGFloat blackKeyOffset = 0.3/self.visibleKeys;
    
    lowestNote = self.lowestOctave*12;
    //self.layer.borderWidth = 0;
    //self.layer.cornerRadius = self.roundess;
    //self.layer.borderColor = self.color.CGColor;
    //self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIImage *left = [UIImage imageNamed:@"leftKey.png"];
    UIImage *center = [UIImage imageNamed:@"centerKey.png"];
    UIImage *right = [UIImage imageNamed:@"rightKey.png"];
    UIImage *black = [UIImage imageNamed:@"blackKey.png"];
    
    // Make two arrays of the entire keyboard (white keys and black keys separately).
    // These arrays hold the correct button image for white keys, and the correct X-position modifier for black keys.
    // This is due to it being a non-symmetrical layout, so the arrays of white and black keys are also non-symmetrical.
    // Also make corresponding arrays of midi note values to use as tags.
    //
    
    // White key array
    NSArray *cde = [[NSArray alloc] initWithObjects:left, center, right, nil];
    NSArray *fgab = [[NSArray alloc] initWithObjects:left, center, center, right, nil];
    NSMutableArray *keyboardWhiteButtonArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < ((2*self.octaves)+1); i++) {
        if (i % 2 == 0) {
            [keyboardWhiteButtonArray addObjectsFromArray:fgab];
        } else {
            [keyboardWhiteButtonArray addObjectsFromArray:cde];
        }
    }
    
    // Black key array
    NSArray *blackKeyTemp = [[NSArray alloc] initWithObjects: @1, @2, @4, @5, @6,  nil];
    NSMutableArray *keyboardBlackButtonArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.octaves; i++) {
        
        for (NSNumber *num in blackKeyTemp) {
            int newNum = [num intValue]+(7*i);
            [keyboardBlackButtonArray addObject:[NSNumber numberWithInt:newNum]];
        }
    }
    
    // White key midi array
    NSArray *whiteMidiTemp = [[NSArray alloc] initWithObjects: @0, @2, @4, @5, @7, @9, @11,nil];
    NSMutableArray *whiteKeyMidi = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.octaves; i++) {
        for (NSNumber *num in whiteMidiTemp) {
            int newNum = lowestNote+([num intValue]+(12*i));
            [whiteKeyMidi addObject:[NSNumber numberWithInt:newNum]];
        }
    }
    
    // Black key midi array
    NSArray *blackMidiTemp = [[NSArray alloc] initWithObjects:@1, @3, @6, @8, @10, nil];
    NSMutableArray *blackKeyMidi = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.octaves; i++) {
        for (NSNumber *num in blackMidiTemp) {
            int newNum = lowestNote+([num intValue]+(12*i));
            [blackKeyMidi addObject:[NSNumber numberWithInt:newNum]];
        }
    }
    
    // Draw the scrollview to contain the keyboard and give it enough size for the keyboard.
    CGRect scrollViewRect = CGRectMake(keyboardXOrigin, keyboardYOrigin, keyboardWidth, keyboardHeight);
    keyboard = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    keyboard.contentSize = CGSizeMake(keyboardWhiteButtonArray.count*whiteKeyWidth, keyboard.frame.size.height);
    keyboard.multipleTouchEnabled = YES;
    keyboard.layer.borderWidth = self.borderSize;
    keyboard.layer.cornerRadius = self.roundess;
    keyboard.layer.backgroundColor = self.color.CGColor;
    keyboard.layer.borderColor = self.color.CGColor;
    
    // Change scrollview to scroll on pan. It seems both min and max number of touches is set to 1, so both need to be changed.
    for (UIGestureRecognizer *gestureRecognizer in keyboard.gestureRecognizers) {
        if ([gestureRecognizer  isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *) gestureRecognizer;
            panGR.minimumNumberOfTouches = self.touchesForScroll;
            panGR.maximumNumberOfTouches = self.touchesForScroll;
        }
    }
    
    // Draw the keyboard buttons - OBShapedButton is a custom class that ignores touches on transparent portions of a .png image.
    // This allows the detection between white and black keys to be smoother. https://github.com/ole/OBShapedButton
    // Also assign the appropriate .tag from the midi arrays.

    // Draw white keys
    tag = 0;
    float fontSize = whiteKeyWidth/3;
    for (UIImage *image in keyboardWhiteButtonArray) {
        OBShapedButton *whiteButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [whiteButton addTarget:self action:@selector(handleKeyboardButtons:) forControlEvents:self.touchBehavior];
        [whiteButton setBackgroundImage:image forState:UIControlStateNormal];    //[keyboardWhiteButtonArray objectAtIndex:tag]
        whiteButton.showsTouchWhenHighlighted = YES;
        whiteButton.tintColor = [UIColor blueColor];
        whiteButton.frame = CGRectMake(whiteKeyWidth*tag, 0, whiteKeyWidth, keyboardHeight);
        
        if (self.hidesNumbers == NO) {
            if (tag % 7 == 0) {
                int octave = ((tag/7)*12)+lowestNote;
                [whiteButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
                [whiteButton setTitle:[NSString stringWithFormat:@"%i",octave] forState:UIControlStateNormal];
                [whiteButton setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
                
                // Adjust the position of the .titleLabel property.
                [whiteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [whiteButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [whiteButton setTitleEdgeInsets:UIEdgeInsetsMake(keyboardHeight-(fontSize*1.5)-(self.borderSize*.8), whiteKeyWidth*(1.5/fontSize)+(self.borderSize*.1), 0, 0)];
            }
        }
        
        whiteButton.tag = [[whiteKeyMidi objectAtIndex:tag] intValue];
        [allTheKeys addObject:whiteButton];
        tag++;
        [keyboard addSubview:whiteButton];
    }
    
    // Draw black keys
    tag = 0;
    for (NSNumber *num in keyboardBlackButtonArray) {
        OBShapedButton *blackButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [blackButton addTarget:self action:@selector(handleKeyboardButtons:) forControlEvents:self.touchBehavior];
        [blackButton setBackgroundImage:black forState:UIControlStateNormal];
        blackButton.showsTouchWhenHighlighted = YES;
        int mod = [num intValue];//[keyboardBlackButtonArray objectAtIndex:tag]
        blackButton.frame = CGRectMake((whiteKeyWidth*mod)-(keyboardWidth*blackKeyOffset), 0, blackKeyWidth, blackKeyHeight);
        
        blackButton.tag = [[blackKeyMidi objectAtIndex:tag] intValue];
        [allTheKeys addObject:blackButton];
        tag++;
        [keyboard addSubview:blackButton];
    }
    
    [self addSubview:keyboard];
    
    
    if (self.shouldDoCoolAnimation == YES) {
        UIGraphicsBeginImageContext(keyboard.frame.size);
            [CATransaction begin];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [CATransaction setCompletionBlock:^{
            }];
                CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
                fillAnimation.duration = self.startupAnimationDuration;
                fillAnimation.fromValue = (id)[UIColor whiteColor].CGColor;
                fillAnimation.toValue = (id)self.color.CGColor;
                fillAnimation.removedOnCompletion = YES;
        
                CABasicAnimation *sizeAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
                sizeAnimation.duration = self.startupAnimationDuration/1.2;
                sizeAnimation.fromValue = @(100);
                sizeAnimation.toValue = @(self.borderSize);
                sizeAnimation.removedOnCompletion = YES;
        
                CABasicAnimation *bgAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
                bgAnimation.duration = self.startupAnimationDuration;
                bgAnimation.fromValue = (id)[UIColor whiteColor].CGColor;
                bgAnimation.toValue = (id)self.color.CGColor;
                bgAnimation.removedOnCompletion = YES;
                
                [keyboard.layer addAnimation:fillAnimation forKey:@"borderColor"];
                [keyboard.layer addAnimation:sizeAnimation forKey:@"borderWidth"];
                [keyboard.layer addAnimation:bgAnimation forKey:@"backgroundColor"];
            [CATransaction commit];
        UIGraphicsEndImageContext();
    }
}

- (void)scrollTo:(float)position withAnimation:(BOOL)animated {
    CGRect frame = CGRectMake(keyboard.contentSize.width*position, 0, keyboard.bounds.size.width, keyboard.bounds.size.height);
    [keyboard scrollRectToVisible:frame animated:animated];
}

- (void)animateScroll:(float)value {
    value = value*keyboard.contentSize.width;
    self.animationID = [INTUAnimationEngine animateWithDuration:0.1f
                                                          delay:0.0f
                                                         easing:INTUEaseInOutQuadratic
                                                        options:INTUAnimationOptionRepeat | INTUAnimationOptionAutoreverse
                                                     animations:^(CGFloat progress) {
                                                         keyboard.contentOffset = CGPointMake(INTUInterpolateCGFloat(keyboard.contentOffset.x, value, progress), 0);
                                                     }
                                                     completion:^(BOOL finished) {
                                                     }];
}

    //Handle clicking buttons. Set the control event for the Viewcontroller to receive updates.
- (IBAction)handleKeyboardButtons:(OBShapedButton *)sender {
    //NSLog(@"Tag: %d",(int)sender.tag);
    
    self.value = (float)sender.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
