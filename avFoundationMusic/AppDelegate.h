//
//  AppDelegate.h
//  avFoundationMusic
//
//  Created by MacBookPro on 10/11/2018.
//  Copyright © 2018 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

