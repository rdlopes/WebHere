//
//  WHViewController.m
//  WebHere
//
//  Created by rdlopes on 09/15/2018.
//  Copyright (c) 2018 rdlopes. All rights reserved.
//

#import "WHViewController.h"
#import "WHSearchResponse.h"
#import "WHSearchRequest.h"
#import "WHSearchResult.h"
#import "UIImageView+AFNetworking.h"

@interface WHViewController () <UISearchBarDelegate>

@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(strong, nonatomic) WHWebsite *googleWebsite;

- (void)fetchResults;

@end

@implementation WHViewController

- (void)fetchResults {
    [self.googleWebsite send:self.searchRequest
                     success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                         self.searchResponse = (id) responseObject;
                         [self.tableView reloadData];
                     }
                     failure:^(WHHTTPRequest *request, NSError *error) {
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleActionSheet];
                         [self presentViewController:alertController animated:YES completion:nil];
                     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize WebHere then search page
    self.googleWebsite = [WHWebsite websiteWithBaseURL:[NSURL URLWithString:@"http://www.google.com/"]];
    self.searchRequest = [[WHSearchRequest alloc] init];
    
    // UI setup
    self.searchBar.showsCancelButton = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResponse != nil
    ? self.searchResponse.searchResults.count
    : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    WHSearchResult *searchResult = self.searchResponse.searchResults[(NSUInteger) indexPath.row];
    
    if (searchResult != nil) {
        cell.textLabel.text = searchResult.label;
        cell.detailTextLabel.text = searchResult.details;
        if (searchResult.imagePath != nil) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:searchResult.imagePath
                                                   relativeToURL:self.googleWebsite.baseURL]];
        }
    }
    
    [cell sizeToFit];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 2) {
        self.searchRequest = [[WHSearchRequest alloc] init];
        self.searchRequest.queryParameters[@"q"] = searchText;
        [self fetchResults];
        
    } else {
        self.searchResponse = nil;
        [self.tableView reloadData];
    }
    
}

@end
