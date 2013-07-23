//
//  TagCell.m
//  Wax
//
//  Created by Christian Hatch on 6/21/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "TagCell.h"

@interface TagCell ()
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@end

@implementation TagCell
@synthesize tagLabel; 
@synthesize tagObject = _tagObject;


-(void)setUpView{
    TagObject *tag = self.tagObject;
    
    self.tagLabel.text = tag.tag;
    
}

#pragma mark - Setters
-(void)setTagObject:(TagObject *)tagObject{
    if (_tagObject != tagObject) {
        _tagObject = tagObject;
        [self setUpView];
    }
}



@end
