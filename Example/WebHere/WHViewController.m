//
//  WHViewController.m
//  WebHere
//
//  Created by Rui Lopes on 12/17/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import "WHViewController.h"

@interface WHViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation WHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.googleWebsite = [WHWebsite websiteWithBaseURL:[[NSURL alloc] initWithString:@"http://www.google.com/"]];
    [self.googleWebsite send:[WHLink linkWithPath:@"" target:[WHGoogleSearchPage class]]
                     success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                         self.googleSearchPage = (id) responseObject;
                     }
                     failure:^(WHHTTPRequest *request, NSError *error) {
                         self.statusLabel.text = [NSString stringWithFormat:@"Could not fetch search page - %@", error.localizedDescription];
                     }];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    //NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    //NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    //NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    //NSLog(@"didDismissSearchController");
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

@end