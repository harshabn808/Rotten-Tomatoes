//
//  MovieCell.h
//  Rotten Tomatoes
//
//  Created by Harsha Badami Nagaraj on 6/8/14.
//  Copyright (c) 2014 Harsha Badami Nagaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *movie;
-(void) setMovieDetails:(NSDictionary *) movie;

@end
