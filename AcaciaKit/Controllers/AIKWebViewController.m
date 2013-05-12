//
//  AIKWebViewController.m
//  Kiwi
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKWebViewController.h"
#import "AcaciaKit.h"   
#import "UIViewController+AcaciaKit.h"

@interface AIKWebViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *urlToLoad; 
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationItem *titleBar;

@end

@implementation AIKWebViewController
@synthesize webView, urlToLoad, navBar, titleBar, pageTitle; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(id)initWithURL:(NSURL *)url pageTitle:(NSString *)apageTitle{
    self = [super init];
    if (self) {
        self.urlToLoad = url;
        self.pageTitle = apageTitle; 
    }
    return self; 
}
- (void)viewDidLoad{
    [super viewDidLoad]; 
    [self initWebView];
    [self initNavBar];
}
-(void)initWebView{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.urlToLoad]];
}
-(void)initNavBar{
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    
    if (self.pageTitle) {
        self.titleBar = [[UINavigationItem alloc] initWithTitle:self.pageTitle];
    }else{
        self.titleBar = [[UINavigationItem alloc] initWithTitle:@""]; 
    }
    self.titleBar.leftBarButtonItem = buttonDone;
    self.titleBar.title = @"Loading...";

    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, 44)];
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.navBar pushNavigationItem:self.titleBar animated:NO];
    [self.view addSubview:self.navBar];
    self.webView.frame = CGRectMake(self.view.frame.origin.x, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
}
-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil]; 
}
-(void)showLoading:(BOOL)loading{
    if (loading) {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIBarButtonItem *loader = [[UIBarButtonItem alloc] initWithCustomView:activity];
        [self.titleBar setRightBarButtonItem:loader animated:YES];
    }else{
        [self.titleBar setRightBarButtonItem:nil animated:YES]; 
    }
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoading:YES]; 
}
- (void)webViewDidFinishLoad:(UIWebView *)awebView {
    [self showLoading:NO];
    
    NSString *docTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![self.pageTitle isEmptyOrNull]) {
        [self.titleBar setTitle:self.pageTitle];
    }else{
        [self.titleBar setTitle:docTitle];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showLoading:NO];
    
    // To avoid getting an error alert when you click on a link before a request has finished loading.
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not load page", nil) message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
