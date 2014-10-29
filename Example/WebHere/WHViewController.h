//
//  WHViewController.h
//  WebHere
//
//  Created by Rui Lopes on 10/20/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHViewController : UIViewController <UISearchResultsUpdating>

@property(nonatomic, weak) IBOutlet UITableView *resultsTableView;

@end
