//
//  AIKWebViewController.h
//  AcaciaKit
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIKWebViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate>


-(id)initWithURL:(NSURL *)url pageTitle:(NSString *)apageTitle;

@property (nonatomic, strong) NSString *pageTitle;

@end

