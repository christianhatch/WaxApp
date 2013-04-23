//
//  CHProgressBar.h
//  AcaciaKit
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIKProgressBar : UIView

@property (nonatomic) BOOL showActivityIndicator;
@property (nonatomic) BOOL showProgressLabel;

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated; 

@end
