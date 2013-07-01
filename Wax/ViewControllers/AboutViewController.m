//
//  AboutViewController.m
//  Wax
//
//  Created by Christian Hatch on 7/1/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"About", @"About"); 
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:@"https://api.wax.li/documents/terms_of_service.html"] pageTitle:NSLocalizedString(@"Terms of Service", @"Terms of Service") presentFromViewController:self];
        }break;
        case 1:{
            [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:@"https://api.wax.li/documents/privacy-policy.html"] pageTitle:NSLocalizedString(@"Privacy Policy", @"Privacy Policy") presentFromViewController:self];
        }break;
        case 2:{
            [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:@"https://api.wax.li/documents/acknowledgements.html"] pageTitle:NSLocalizedString(@"Acknowledgements", @"Acknowledgements") presentFromViewController:self];
        }break;
    }    
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *title = nil;
    if (section == 0) {
        title = [NSString stringWithFormat:NSLocalizedString(@"%@\nCopyright \u00A9 2013 Acacia Interactive", @"%@\nCopyright \u00A9 2013 Acacia Interactive"), [NSString appNameVersionAndBuildString]];
    }
    return title;
}

@end
