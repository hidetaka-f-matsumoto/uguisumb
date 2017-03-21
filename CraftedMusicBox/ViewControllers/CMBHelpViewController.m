//
//  CMBHelpViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2015/02/01.
//  Copyright (c) 2015年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBHelpViewController.h"
#import "CMBUtility.h"

@interface CMBHelpViewController ()

@end

@implementation CMBHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView.delegate = self;
    _webView.scalesPageToFit = NO;
    
    NSURL *url = [NSURL URLWithString:CMBSvURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    // ロード中表示
    [self loadingBeginWithNetwork:NO];
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
    [_webView goBack];
}

- (IBAction)forwardButtonDidTap:(id)sender {
    [_webView goForward];
}

- (IBAction)refleshButtonDidTap:(id)sender {
    [_webView reload];
}

- (void)updateButtonsWithWebView:(UIWebView *)webView {
    _forwardButton.enabled = webView.canGoForward;
    _backButton.enabled = webView.canGoBack;
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
    // ロード中表示
    [self loadingEndWithNetwork:NO];
}

@end
