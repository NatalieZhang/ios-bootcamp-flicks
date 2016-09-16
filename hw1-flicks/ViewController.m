//
//  ViewController.m
//  hw1-flicks
//
//  Created by Natalie(Yuanyuan) Zhang on 9/15/16.
//  Copyright © 2016 Natalie(Yuanyuan) Zhang. All rights reserved.
//

#import "ViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* movies;
@property (nonatomic, strong) UIRefreshControl *flicksRefreshControl;
@property (weak, nonatomic) IBOutlet UITableView *flicksTableView;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flicksTableView.dataSource = self;
    self.flicksTableView.delegate = self;
    [self getMoviesData];
    
    self.flicksRefreshControl = [[UIRefreshControl alloc] init];
    [self.flicksRefreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.flicksTableView insertSubview:self.flicksRefreshControl atIndex:0];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)onRefresh {
    [self getMoviesData];
}

- (void)getMoviesData {
    
    // create a movie model,
    
//    Movie.topMovies(completion:^(NSArray *movies, NSError *error)) {
  //      if (error == nil) {
    //        self.movies = movies;
      //      [self.tableView reloadData];
        //}
//    }
    
    
    
    
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *nowPlayingUrlString =
    [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    NSString *topRatedUrlString =
    [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString:nowPlayingUrlString];
    if ([self.endpoint isEqualToString:@"top_rated"]) {
        url = [NSURL URLWithString:topRatedUrlString];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [self.flicksRefreshControl endRefreshing];
                                                [self setTableView];
                                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.movies = responseDictionary[@"results"];
                                                    [self.flicksTableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    [self.flicksTableView setHidden:true];
                                                    [self.networkErrorView setHidden:false];
                                                }
                                            }];
    [task resume];
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setTableView];
}

- (void)setTableView {
    CGRect rect = self.navigationController.navigationBar.frame;
    float y = rect.size.height + rect.origin.y;
    self.flicksTableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.movieInfoLabel.text = movie[@"overview"];
    
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w45/" stringByAppendingString:movie[@"poster_path"]]]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.flicksTableView indexPathForCell:cell];
    
    MovieDetailViewController *vc = segue.destinationViewController;
    
    vc.movie = self.movies[indexPath.row];
}

@end
