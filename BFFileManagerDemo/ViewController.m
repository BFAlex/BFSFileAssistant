//
//  ViewController.m
//  BFFileManagerDemo
//
//  Created by BFsAlex on 2018/9/12.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "ViewController.h"
#import "BFFileManager_old.h"
#import "BFFileStream.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testPhotoFile];
//    [self testVideoFile];
//
//    NSArray *dirtNames = @[@"A", @"B", @"", @"C"];
//    NSString *testDir1 = [[BFFileManager defaultManager] getDirectoryPathFromDirectories:dirtNames isBaseOnDocuments:NO];
//    NSString *testDir2 = [[BFFileManager defaultManager] getDirectoryPathFromDirectories:dirtNames isBaseOnDocuments:YES];
//    NSLog(@"test dir1: %@", testDir1);
//    NSLog(@"test dir2: %@", testDir2);
    
//    [self testFS];
    
//    [self testAAA];
    [self useLock];
}

- (void)testAAA {
    
//    dispatch_semaphore_t sp = dispatch_semaphore_create(1);
    NSLock *lock = [[NSLock alloc] init];
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < 10; i++) {
        
//        long r = dispatch_semaphore_wait(sp, 5);
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [lock lock];
            [NSThread sleepForTimeInterval:2];
            NSLog(@"g thread(%d): %@", i, [NSThread currentThread]);
            //            dispatch_semaphore_signal(sp);
//            [lock unlock];
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                NSLog(@"非主线程中回调：%@", [NSThread currentThread]);
                [weakSelf testBBBB];
            });
        });
        
    
//        r = dispatch_semaphore_wait(sp, 5);
//        if (0 == r) {
            NSLog(@"111111");
//        } else {
//            NSLog(@"222222");
//        }
    }
}

- (void)testBBBB {
    NSLog(@"BBBBBBBB");
}

- (void)testFS {
    
    [BFFileStream fileStream];
}

- (void)testVideoFile {
    
    BFFileManager_old *fm = [BFFileManager_old defaultManager];
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"video.MOV" ofType:nil];
    NSString *toPath = [fm getFilePath:@"test_video.mov" fromDirectoryPath:[fm getDirectoryPathFromDirectories:@[@"Video"]]];
    NSLog(@"to path: \n%@", toPath);
    if (videoPath.length > 0 && toPath.length > 0) {
        [fm moveFileFromPath:videoPath toPath:toPath];
    }
}

- (void)testPhotoFile {
    
    BFFileManager_old *fm = [BFFileManager_old defaultManager];
    NSString *testFolderName = @"TestFolder";
    
    [fm fileExists:@"test.png" inDirectoryPath:[fm getDirectoryPathFromDirectories:@[testFolderName]]];
    
    UIImage *img = [UIImage imageNamed:@"photo.jpg"];
    NSString *fileJPGPath = [fm getFilePath:@"test_photo.jpg" fromDirectoryPath:[fm getDirectoryPathFromDirectories:@[testFolderName]]];
    BOOL resultJPG = [fm saveFile:UIImageJPEGRepresentation(img, 1.0) toPath:fileJPGPath];
    NSLog(@"resultJPG: %d", resultJPG);
    NSString *filePNGPath = [fm getFilePath:@"test_photo.png" fromDirectoryPath:[fm getDirectoryPathFromDirectories:@[testFolderName]]];
    [fm saveFile:UIImagePNGRepresentation(img) toPath:filePNGPath];
    NSString *filePath = [fm getFilePath:@"test_photo" fromDirectoryPath:[fm getDirectoryPathFromDirectories:@[testFolderName]]];
    [fm saveFile:UIImagePNGRepresentation(img) toPath:filePath];
    
    [fm fileExists:@"test_photo.jpg" inDirectoryPath:[fm getDirectoryPathOfFolderInDocumentsDirectory:testFolderName]];
}

- (void)useLock {
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3 * SEC_OS_OSX);
    for (int i = 0; i < 6; i ++) {
        NSLog(@"1:%@", [NSThread currentThread]);
        long r1 = dispatch_semaphore_wait(signal, timeout);
        NSLog(@"r1(%d):%ld", i, r1);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"异步线程：%@", [NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"异步回调线程：%@", [NSThread currentThread]);
                dispatch_semaphore_signal(signal);
            });
        });
    }
    
    NSRunLoop *rl;
}

@end
