//
//  MovieDetailViewController.m
//  hw1-flicks
//
//  Created by Natalie(Yuanyuan) Zhang on 9/16/16.
//  Copyright © 2016 Natalie(Yuanyuan) Zhang. All rights reserved.
//

#import "MovieDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *movieBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *length;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *movieDetailScrollView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [@"https://api.themoviedb.org/3/movie/" stringByAppendingFormat:@"%@?api_key=%@", self.movie[@"id"], apiKey];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    int runtime = [responseDictionary[@"runtime"] intValue];
                                                    
                                                    int hours = runtime / 60;
                                                    int minutes = runtime % 60;
                                                    self.length.text = [NSString stringWithFormat:@"%d hr %d mins", hours, minutes];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
    
    
    NSInteger vote = [self.movie[@"vote_average"] floatValue] * 10;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *releaseDate = [dateFormatter dateFromString:self.movie[@"release_date"]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    self.movieTitle.text = self.movie[@"title"];
    self.releaseDate.text = [dateFormatter stringFromDate:releaseDate];
    self.rating.text = [NSString stringWithFormat:@"%d", vote];
    self.length.text = @"Runtime";
    
    self.movieDescription.text = self.movie[@"overview"];
    [self.movieDescription sizeToFit];
    
    CGRect frame = self.infoView.frame;
    frame.size.height = self.movieDescription.frame.size.height + self.movieDescription.frame.origin.y + 10;
    self.infoView.frame = frame;
    
    self.movieDetailScrollView.contentSize = CGSizeMake(self.movieDetailScrollView.frame.size.width, 60 + self.infoView.frame.origin.y + self.infoView.frame.size.height);
    
    [self.movieBackgroundImage setImageWithURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w342/" stringByAppendingString:self.movie[@"poster_path"]]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
