//
//  MovieTableViewCell.h
//  hw1-flicks
//
//  Created by Natalie(Yuanyuan) Zhang on 9/15/16.
//  Copyright © 2016 Natalie(Yuanyuan) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieInfoLabel;


@end
