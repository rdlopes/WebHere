//
//  WHViewController.m
//  WebHere
//
//  Created by Rui Lopes on 10/20/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import "WHViewController.h"
#import "GSearchPage.h"
#import "GSearchResultsPage.h"
#import "WHHTTPRequest+Internal.h"

@interface WHViewController () <UITableViewDataSource, UITableViewDelegate,
        UISearchControllerDelegate>

@property(nonatomic, strong) WHWebsite *googleWebSite;
@property(nonatomic, strong) GSearchPage *searchPage;
@property(nonatomic, strong) GSearchResultsPage *searchResultsPage;
@property(nonatomic, strong) UISearchController *searchController;

@end

@implementation WHViewController

- (void)setSearchResultsPage:(GSearchResultsPage *)searchResultsPage {
    _searchResultsPage = searchResultsPage;
    [self.resultsTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.googleWebSite = [[WHWebsite alloc]
                                     initWithBaseURL:[NSURL URLWithString:@"http://google.com/"]];

    // Initialize UI states
    self.searchController =
            [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame =
            CGRectMake(0.0, 0.0, CGRectGetWidth(self.resultsTableView.frame), 44.0);
    self.resultsTableView.tableHeaderView = self.searchController.searchBar;

    // Start by loading the main search page from Google
    WHLink *link = [WHLink linkWithPath:@"" target:[GSearchPage class]];
    [self.googleWebSite send:link
                     success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                         self.searchPage = responseObject;
                     }
                     failure:^(WHHTTPRequest *request, NSError *error) {
                         // Error while downloading
                         NSLog(@"Error: %@", error);
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (self.searchResultsPage && self.searchResultsPage.searchResults != nil) {
        return self.searchResultsPage.searchResults.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    if (cell) {
        WHLink *resultLink =
                self.searchResultsPage.searchResults[(NSUInteger) indexPath.row];
        cell.textLabel.text = resultLink.label;
        cell.detailTextLabel.text = resultLink.userInfo[@"result.description"];
    }

    return cell;
}

- (void)updateSearchResultsForSearchController:
        (UISearchController *)searchController {
    if (self.searchPage && searchController.searchBar.text.length) {
        self.searchPage.searchForm.queryParameters[@"q"] =
                searchController.searchBar.text;
        [self.googleWebSite send:self.searchPage.searchForm
                         success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                             self.searchResultsPage = responseObject;
                         }
                         failure:^(WHHTTPRequest *request, NSError *error) {
                             NSLog(@"Error: %@", error);
                         }];
    } else {
        self.searchResultsPage = nil;
    }
}

@end
