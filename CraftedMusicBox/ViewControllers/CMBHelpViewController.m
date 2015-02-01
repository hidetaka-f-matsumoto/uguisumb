//
//  CMBHelpViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2015/02/01.
//  Copyright (c) 2015年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBHelpViewController.h"

@interface CMBHelpViewController ()

@end

@implementation CMBHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView.delegate = self;
    _webView.scalesPageToFit = NO;
    
    NSURL* url = [NSURL URLWithString: @"http://google.com"];
    NSURLRequest* myRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:myRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonDidTap:(id)sender {
    if (_webView.canGoBack) {
        [_webView goBack];
    }
}

- (IBAction)forwardButtonDidTap:(id)sender {
    if (_webView.canGoForward) {
        [_webView goForward];
    }
}

- (IBAction)reloadButtonDidTap:(id)sender {
    [_webView reload];
}

- (void)updateButtonsWithWebView:(UIWebView *)webView {
    _forwardButton.enabled = webView.canGoForward;
    _backButton.enabled = webView.canGoBack;
    _refleshButton.style = webView.loading ? UIBarButtonSystemItemRefresh : UIBarButtonSystemItemStop;
}

# pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // ボタン状態を更新
    [self updateButtonsWithWebView:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // ボタン状態を更新
    [self updateButtonsWithWebView:webView];
}

@end
