//
//  WaxEmptyView.m
//  Wax
//
//  Created by Christian Hatch on 7/24/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxEmptyView.h"

@interface WaxEmptyView ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation WaxEmptyView
@synthesize state = _state, labelText = _labelText;

+(WaxEmptyView *)emptyViewWithFrame:(CGRect)frame{
    WaxEmptyView *empty = [[[NSBundle mainBundle] loadNibNamed:@"WaxEmptyView" owner:self options:nil] objectAtIndexOrNil:0];
    empty.frame = frame;
    return empty; 
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.imageView.image = [UIImage imageNamed:@"error_image"]; 
    [self.statusLabel setWaxHeaderFontOfSize:15 color:[UIColor waxHeaderFontColor]];
    self.backgroundColor = [UIColor whiteColor];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.statusLabel.text = self.labelText;
}

-(void)updateForStateChange{
    
    switch (self.state) {
        case EmptyViewStateInitial:{
            
            self.imageView.hidden = YES;
            self.statusLabel.hidden = YES;
            [self.spinner startAnimating];

        }break;
        case EmptyViewStateStandard:{

            self.statusLabel.text = self.labelText;
            self.imageView.hidden = NO;
            self.statusLabel.hidden = NO;
            [self.spinner stopAnimating];
            
        }break;
    }
}

#pragma mark - Accessors
-(void)setState:(WaxEmptyViewState)state{
    _state = state;
    [self updateForStateChange]; 
}

-(void)setLabelText:(NSString *)labelText{
    if (![labelText isEqualToString:self.statusLabel.text]) {
        
        _labelText = labelText;
        
        self.statusLabel.text = self.labelText; 
    }
}
-(NSString *)labelText{
    if (!_labelText) {
        _labelText = NSLocalizedString(@"No Content :(", @"No Content :(");
    }
    return _labelText;
}



@end
