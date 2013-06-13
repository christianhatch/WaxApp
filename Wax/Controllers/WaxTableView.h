//
//  WaxTableView.h
//  Wax
//
//  Created by Christian Hatch on 6/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaxTableView : UITableView <UITableViewDataSource, UITableViewDelegate> 


-(void)stopAnimatingReloaderViews;

@property (nonatomic, readwrite) BOOL automaticallyDeselectRow;


@end
