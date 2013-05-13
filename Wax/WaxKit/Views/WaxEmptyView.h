//
//  CHEmptyView.h
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaxEmptyView : UIView


-(id)initWithMessage1:(NSString *)message1 message2:(NSString *)message2 image:(UIImage *)image buttonLabel:(NSString *)buttonLabel actionHandler:(void (^)(void))actionHandler;

@end
