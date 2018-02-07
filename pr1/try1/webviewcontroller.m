//
//  webviewcontroller.m
//  try1
//
//  Created by smile on 2017/9/5.
//  Copyright © 2017年 smile. All rights reserved.
//

#import "webviewcontroller.h"
#import "WebModel.h"

@interface webviewcontroller ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) WebModel* myWebModel;

@end

@implementation webviewcontroller
@synthesize indexUseWeb = _indexUseWeb;



-(WebModel*)myWebModel{
    
    if(!_myWebModel)
        _myWebModel = [WebModel sharedInstance];
    
    return _myWebModel;
}

-(NSInteger)indexUseWeb{
    
    if(!_indexUseWeb)
        _indexUseWeb = 0;
    
    return _indexUseWeb;
}

- (instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if(self){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _webView.frame = self.view.frame;
    _webView.delegate = self;
    NSString* s=[self.myWebModel webLinksInteger:_indexUseWeb];
    NSLog(@"url = %@",s);
    if(s != nil){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:s]];
        [_webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // NSLog(@"didFailLoadWithError");
}/*
  #pragma mark - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */

@end
