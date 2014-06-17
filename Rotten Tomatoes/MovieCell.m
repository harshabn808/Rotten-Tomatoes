//
//  MovieCell.m
//  Rotten Tomatoes
//
//  Created by Harsha Badami Nagaraj on 6/8/14.
//  Copyright (c) 2014 Harsha Badami Nagaraj. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieCell ()

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation MovieCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setMovieDetails:(NSDictionary *) movie{
    self.movie = movie;
    NSString *imageUrl = movie[@"posters"][@"thumbnail"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    self.movieTitleLabel.text = movie[@"title"];
    self.synopsisLabel.text = movie[@"synopsis"];
    [self.posterView setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"1x1"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.posterView.image = image;
        self.posterView.alpha = 0.0;
        [UIView animateWithDuration:3.0 animations:^{
            self.posterView.alpha = 1.0;
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    
}
@end
