//
//  Slot.m
//  BestAdmobIAd
//
//  Created by Charles-Hubert Basuiau on 18/11/2013.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

//
// You can improve and custom this code as you want :
// You can use iAd and Admob Delegate to show view only when content is loaded for example
// animate it... etc...
// I already manage the high ratio of iAd response failed (but it's my own way you can do yours
//

#import "Slot.h"
#import "GADBannerView.h"
#import <iAd/iAd.h>

#define URL_RATIO   @"http://www.applinnov.com/bestad/ratio.php?opt=json"
#define URL_CLICK   @"http://www.applinnov.com/bestad/clic.php"

typedef enum {
    ADMOB   = 0,
    IAD     =1
} ADSERVERS ;

@interface Slot () <ADBannerViewDelegate, GADBannerViewDelegate> {
    ADBannerView *_bannerView;
    GADBannerView *bannerView_;
}

@end

@implementation Slot

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Request for ratios of iad and admob

    NSURL *url = [NSURL URLWithString:URL_RATIO];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSInteger ratioIAd = (int)([[json objectForKey:@"iad"] floatValue]*100.0);
        
        NSInteger random = arc4random()%10000;
        if (random > ratioIAd) {
            [self showAdmob];
        } else {
            [self showiAd];
        }
    }];
    
    [self showAdmob];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Feedback

-(void)clickOnAdserver:(ADSERVERS)adserver {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?c=%d", URL_CLICK, adserver]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         //If you want you can adjust the next ad in adding '&opt=json' at the url end : you will receive the new value of iad and admob repartition
     }];}

#pragma mark - Instance iAd and Admob

/*
 * Admob
 **/
-(void)showAdmob {
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height-GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    bannerView_.adUnitID = @"ca-app-pub-8966227509906772/7221049645";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    GADRequest *req = [GADRequest request];
    req.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,                               // Simulator
                           nil];
    [bannerView_ loadRequest:req];
}

/*
 * iAd
 **/
-(void)showiAd {
    // On iOS 6 ADBannerView introduces a new initializer, use it when available.
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        _bannerView = [[ADBannerView alloc] init];
    }
    _bannerView.delegate = self;
    [_bannerView setFrame:CGRectMake(0.0,
                                    self.view.frame.size.height-GAD_SIZE_320x50.height,
                                    GAD_SIZE_320x50.width,
                                    GAD_SIZE_320x50.height)];
    [self.view addSubview:_bannerView];
}

#pragma Delegate iAd and Admob

/*
 * Admob
 **/

//Clic
-(void)adViewWillPresentScreen:(GADBannerView *)adView {
    [self clickOnAdserver:ADMOB];
}

/*
 * iAd
 **/

// Clic
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [self clickOnAdserver:IAD];
    return NO;
}

// manage when iad does not answer
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self showAdmob];
}


@end
