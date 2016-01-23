//
//  ViewController.h
//  WebHere
//
//  Created by Rui Lopes on 21/01/2016.
//  Copyright © 2016 Rui Lopes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHSearchRequest;
@class WHSearchResponse;

@interface ViewController : UITableViewController

@property(strong, nonatomic) WHSearchRequest *searchRequest;
@property(strong, nonatomic) WHSearchResponse *searchResponse;

@end

