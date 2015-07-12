//
//  LoginViewController.m
//  Blocstagram
//
//  Created by Mac on 7/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "LoginViewController.h"
#import "DataSource.h"

@interface LoginViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;

@end

@implementation LoginViewController

NSString *const LoginViewControllerDidGetAccessTokenNotification = @"LoginViewControllerDidGetAccessTokenNotification";


- (void)loadView {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    
    self.webView = webView;
    self.view = webView;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Login", @"Login");
    
    //create the back button in the navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", [DataSource instagramClientID], [self redirectURI]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

//This method determines if the webview can go or not backwards
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    if (self.webView.canGoBack) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.title = @"Back";
    } else {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.title = @"";
    }
}

- (NSString *)redirectURI {
    return @"https://www.bloc.io/users/carlos-gomez/checkpoints";
}

- (void) viewWillLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    // Removing this line can cause a flickering effect when you relaunch the app after logging in, as the web view is briefly displayed, automatically authenticates with cookies, returns the access token, and dismisses the login view, sometimes in less than a second.
    [self clearInstagramCookies];
    
    // see https://developer.apple.com/library/ios/documentation/uikit/reference/UIWebViewDelegate_Protocol/Reference/Reference.html#//apple_ref/doc/uid/TP40006951-CH3-DontLinkElementID_1
    self.webView.delegate = nil;
}

/**
 Clears Instagram cookies. This prevents caching the credentials in the cookie jar.
 */
- (void) clearInstagramCookies {
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSRange domainRange = [cookie.domain rangeOfString:@"instagram.com"];
        if(domainRange.location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = request.URL.absoluteString;
    if ([urlString hasPrefix:[self redirectURI]]) {
        // This contains our auth token
        NSRange rangeOfAccessTokenParameter = [urlString rangeOfString:@"access_token="];
        NSUInteger indexOfTokenStarting = rangeOfAccessTokenParameter.location + rangeOfAccessTokenParameter.length;
        NSString *accessToken = [urlString substringFromIndex:indexOfTokenStarting];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginViewControllerDidGetAccessTokenNotification object:accessToken];
        
        return NO;
    }
    
    return YES;
}


//This button handles the event of the back button being tapped
- (void)backButtonPressed:(id)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

@end
