//
//  WHViewController.m
//  WebHere
//
// Created by Rui Lopes on 06/10/2014.
//
// Copyright (c) 2013 Rui D Lopes
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
