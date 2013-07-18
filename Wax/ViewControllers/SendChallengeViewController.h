//
//  SendChallengeViewController.h
//  Wax
//
//  Created by Christian Hatch on 7/16/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendChallengeViewController : UIViewController

+(SendChallengeViewController *)sendChallengeViewControllerWithChallengeTag:(NSString *)tag challengeVideoID:(NSString *)videoID shareID:(NSString *)shareID;


@end
