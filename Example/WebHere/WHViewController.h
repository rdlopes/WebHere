//
//  WHViewController.h
//  WebHere
//
//  Created by Rui Lopes on 12/17/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebHere/WebHere.h>
#import "WHGoogleSearchPage.h"

@interface WHViewController : UIViewController

@property(nonatomic, strong) WHGoogleSearchPage *googleSearchPage;
@property(nonatomic, strong) WHWebsite *googleWebsite;

@end
