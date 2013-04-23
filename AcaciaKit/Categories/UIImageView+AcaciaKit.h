//
//  UIImageView+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 2/10/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AcaciaKit)

- (void)setImageWithURL:(NSURL *)url andPlaceholderAnimation:(BOOL)placeholderAnimation;


-(void)setImage:(UIImage *)image animated:(BOOL)animated;
-(void)setImage:(UIImage *)image animated:(BOOL)animated duration:(CGFloat)duration; 

@end
