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
    
//#ifdef DEBUG
//    self.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
//    self.layer.borderWidth = (fminf(self.bounds.size.width, self.bounds.size.height))/10;
//    self.layer.borderColor = [UIColor colorWithRed:0 green:1 blue:0.8 alpha:1].CGColor;
//    
//    self.statusLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
//    self.statusLabel.layer.borderWidth = (fminf(self.statusLabel.bounds.size.width, self.statusLabel.bounds.size.height))/10;
//    self.statusLabel.layer.borderColor = [UIColor colorWithRed:0 green:0.4 blue:1 alpha:1].CGColor;
//    
//    self.imageView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
//    self.imageView.layer.borderWidth = (fminf(self.imageView.bounds.size.width, self.imageView.bounds.size.height))/10;
//    self.imageView.layer.borderColor = [UIColor colorWithRed:1 green:0.4 blue:0 alpha:1].CGColor;
//    
//    self.alpha = 0.5; 
//#endif
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
