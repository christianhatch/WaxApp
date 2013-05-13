//
//  WaxAutoCompleter.h
//  Kiwi
//
//  Created by Christian Hatch on 12/30/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//
enum{
    CHAutoCompleteSourceTypeUsers = 1,
    CHAutoCompleteSourceTypeHashTags,
};
typedef NSInteger CHAutoCompleteSourceType;


#define kUsersArray     @"usersArray"
#define kHashTagsArray  @"hashtagsArray"

#import <UIKit/UIKit.h>

@interface WaxAutoCompleter : UITableView <UITableViewDataSource, UITableViewDelegate>

-(id)initWithFrame:(CGRect)frame textView:(UITextView *)atextView;

-(void)searchAutoCompleteWithString:(NSString *)string;
-(void)hideOptionsView;
-(BOOL)isShowing;

@end
