//
//  WaxRoundButton.m
//  Wax
//
//  Created by Christian Hatch on 6/27/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

NSString *const WaxControlStateNormal = @"waxControlStateNormal";
NSString *const WaxControlStateHighlighted = @"waxControlStateHighlighted";
NSString *const WaxControlStateDisabled = @"waxControlStateDisabled";
NSString *const WaxControlStateSelected = @"waxControlStateSelected";
NSString *const WaxControlStateUnknown = @"waxControlStateUnknown";

static inline NSString * WaxControlStateFromUIControlState(UIControlState state) {
    switch (state) {
        case UIControlStateNormal:
            return WaxControlStateNormal;
            break;
        case UIControlStateHighlighted:
            return WaxControlStateHighlighted;
            break;
        case UIControlStateDisabled:
            return WaxControlStateDisabled;
            break;
        case UIControlStateSelected:
            return WaxControlStateSelected;
            break;
        default:
            return WaxControlStateUnknown;
            break;
    }
}



#import "WaxRoundButton.h"

@interface WaxRoundButton ()
@property (nonatomic, strong) NSMutableDictionary *fillColors;
@property (nonatomic, strong) NSMutableDictionary *borderColors;
@end

@implementation WaxRoundButton
@synthesize fillColors = _fillColors, borderColors = _borderColors;

#pragma mark - Public API
+(id)waxRoundButtonGrey{
    WaxRoundButton *btn = [WaxRoundButton buttonWithType:UIButtonTypeCustom];
    [btn styleAsWaxRoundButtonGreyWithTitle:nil];
    return btn; 
}
+(id)waxRoundButtonBlue{
    WaxRoundButton *btn = [WaxRoundButton buttonWithType:UIButtonTypeCustom];
    [btn styleAsWaxRoundButtonBlueWithTitle:nil];
    return btn;
}
+(id)waxRoundButtonWhite{
    WaxRoundButton *btn = [WaxRoundButton buttonWithType:UIButtonTypeCustom];
    [btn styleAsWaxRoundButtonWhiteWithTitle:nil];
    return btn;
}
-(void)styleAsWaxRoundButtonGreyWithTitle:(NSString *)title{
    self.fillColors = [NSMutableDictionary dictionaryWithDictionary:
                       @{WaxControlStateNormal: [UIColor whiteColor],
                    WaxControlStateHighlighted: [UIColor waxTableViewCellSelectionColor]}];
    
    self.borderColors = [NSMutableDictionary dictionaryWithDictionary:
                         @{WaxControlStateNormal: [UIColor waxTableViewCellSelectionColor]}];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self setTitleForAllControlStates:title]; 
}
-(void)styleAsWaxRoundButtonBlueWithTitle:(NSString *)title{
    self.fillColors = [NSMutableDictionary dictionaryWithDictionary:
                       @{WaxControlStateNormal: [UIColor clearColor],
                    WaxControlStateHighlighted: [UIColor blueColor],
                       WaxControlStateDisabled: [UIColor blueColor]}];
    
    self.borderColors = [NSMutableDictionary dictionaryWithDictionary:
                         @{WaxControlStateNormal: [UIColor blueColor],
                        }];
    
    [self setTitleForAllControlStates:title];
}
-(void)styleAsWaxRoundButtonWhiteWithTitle:(NSString *)title{
    self.fillColors = [NSMutableDictionary dictionaryWithDictionary:
                       @{WaxControlStateNormal: [UIColor clearColor],
                    WaxControlStateHighlighted: [UIColor whiteColor]}];
    
    self.borderColors = [NSMutableDictionary dictionaryWithDictionary:
                         @{WaxControlStateNormal: [UIColor whiteColor]}];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self setTitleForAllControlStates:title];
}

-(void)setBorderAndFillColor:(UIColor *)color forState:(UIControlState)state{
    [self setBorderColor:color forState:state];
    [self setFillColor:color forState:state]; 
}
#pragma mark - Alloc & Init
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVariables];
    }
    return self; 
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeVariables];
    }
    return self;
}
-(void)initializeVariables{
    self.titleLabel.font = [UIFont waxDefaultFont]; 

    self.fillColors = [NSMutableDictionary dictionaryWithDictionary:
                       @{WaxControlStateNormal: [UIColor whiteColor],
                    WaxControlStateHighlighted: [UIColor waxTableViewCellSelectionColor],
                       WaxControlStateDisabled: [UIColor darkGrayColor]}];
    
    self.borderColors = [NSMutableDictionary dictionaryWithDictionary:
                         @{WaxControlStateNormal: [UIColor waxTableViewCellSelectionColor],
                         WaxControlStateDisabled: [UIColor darkGrayColor]}];
    
    [self setTitleColor:[UIColor waxHeaderFontColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled]; 
}


#pragma mark - Getters
-(UIColor *)fillColorForControlState:(UIControlState)state{
    UIColor *color = [self.fillColors objectForKeyOrNil:WaxControlStateFromUIControlState(state)];
    if (!color) {
        return [self.fillColors objectForKeyOrNil:WaxControlStateNormal] ? [self.fillColors objectForKeyOrNil:WaxControlStateNormal] : [UIColor whiteColor]; 
    }
    return color;
}

-(UIColor *)borderColorForControlState:(UIControlState)state{
    UIColor *color = [self.borderColors objectForKeyOrNil:WaxControlStateFromUIControlState(state)];
    if (!color) {
        return [self.borderColors objectForKeyOrNil:WaxControlStateNormal] ? [self.borderColors objectForKeyOrNil:WaxControlStateNormal] : [UIColor blackColor];
    }
    return color;
}

#pragma mark - Setters
-(void)setBorderColor:(UIColor *)color forState:(UIControlState)state{
    if (color) {
        [self.borderColors setObject:color forKey:WaxControlStateFromUIControlState(state)]; 
    }
}
-(void)setFillColor:(UIColor *)color forState:(UIControlState)state{
    if (color) {
        [self.fillColors setObject:color forKey:WaxControlStateFromUIControlState(state)];
    }
}


#pragma mark - Drawing Code
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGColorRef strokeColor = [self borderColorForControlState:self.state].CGColor;
    CGColorRef fillColor = [self fillColorForControlState:self.state].CGColor;
        
    CGContextSetFillColorWithColor(ctx, fillColor);
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    
    CGContextSaveGState(ctx);
    
    CGFloat lineWidth = 2.0; //self.bold ? kFlatPillButtonBoldLineWidth : kFlatPillButtonNormalLineWidth;
    
    CGContextSetLineWidth(ctx, lineWidth);
    
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth, lineWidth) cornerRadius:self.bounds.size.height/2];
    
    CGContextAddPath(ctx, outlinePath.CGPath);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
    if (self.highlighted || !self.enabled) {
        CGContextSaveGState(ctx);
        UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth * 2.5, lineWidth * 2.5) cornerRadius:self.bounds.size.height/2];
        
        CGContextAddPath(ctx, fillPath.CGPath);
        CGContextFillPath(ctx);
        
        CGContextRestoreGState(ctx);
    }
}
#pragma mark - Overrides
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}





@end
