//
//  VideoTableViewController.m
//  XML Parser
//
//  Created by Nikolay on 06.03.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "VideoTableViewController.h"
#import "Parser.h"
#import "ViewController.h"
#import "VideoData.h"

@interface VideoTableViewController ()

@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) Parser *parser;
@end

@implementation VideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parserInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)parserInit{
    self.parser =[[Parser alloc]init];
    [self.parser parserStart];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parser.videoArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *thumbnails =[NSArray arrayWithArray:[[self.parser.videoArray objectAtIndex:indexPath.row]thumbnailURL]];
    NSURL *imageURL = [NSURL URLWithString:[thumbnails objectAtIndex:2]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *imageLoad = [[UIImage alloc] initWithData:imageData];
    
    cell.imageView.frame = CGRectMake(0, 0, 120, 90);
    cell.imageView.clipsToBounds = YES;
    cell.imageView.image = imageLoad;
    
    cell.textLabel.text = [[self.parser.videoArray objectAtIndex:indexPath.row]videoTitle];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:14];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 3;
    
    unsigned short int sekunden = [[[self.parser.videoArray objectAtIndex:indexPath.row]videoLingth]integerValue];
    unsigned short int stunden = sekunden/3600;
    sekunden -= stunden * 3600;
    unsigned short int minuten = sekunden / 60;
    sekunden -= minuten * 60;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Dauer: %i:%i:%i", stunden, minuten, sekunden];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"video"]) {
        ViewController *vvc = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        vvc.videoURL = [[self.parser.videoArray objectAtIndex:indexPath.row]videoURL];
        return;
    }
}


@end
