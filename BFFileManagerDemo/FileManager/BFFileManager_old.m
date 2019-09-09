//
//  BFFileManager.m
//  BFFileManagerDemo
//
//  Created by BFsAlex on 2018/9/12.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFFileManager_old.h"

typedef enum {
    
    BFFileTypeUnknown = 0,
    BFFileTypePhoto,
    BFFileTypeVideo,
    BFFileTypeDirectory,
    
} BFFileType;

@interface BFFileManager_old()
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation BFFileManager_old

#pragma mark - Property

- (NSFileManager *)fileManager {
    
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

#pragma mark - API

+ (instancetype)defaultManager {
    
    static BFFileManager_old *fm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fm = [[BFFileManager_old alloc] init];
    });
    
    return fm;
}

- (BOOL)fileExists:(NSString *)fileName inDirectoryPath:(NSString *)directoryPath {
    
    // 方法一
//    BOOL fExists = NO;
//    NSArray *files = [self getFilesInFolder:folderName];
//    for (NSString *file in files) {
//        NSLog(@"文件[%@]类型为：%d", file, [self checkFileType:file]);
//        if ([fileName isEqualToString:file]) {
//            fExists = YES;
//        }
//    }
    
    // 方法二
    NSString *filePath = [self getFilePath:fileName fromDirectoryPath:directoryPath];
    BOOL fExists = [self.fileManager fileExistsAtPath:filePath];
    
    return fExists;
}

- (NSString *)getFilePath:(NSString *)fileName fromDirectoryPath:(NSString *)dirtPath {
    
    NSString *filePath = [dirtPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

- (NSArray *)getFilesFromDirectoryPath:(NSString *)directoryPath {
    
    NSMutableArray *files = [NSMutableArray array];
    NSError *fError;
    
    NSArray *fileList = [self.fileManager contentsOfDirectoryAtPath:directoryPath error:&fError];
    for (NSString *file in fileList) {
        NSLog(@"%@子目录之一：%@", self.fileManager, file);
        if (file) {
            [files addObject:file];
        }
    }
    
    return files;
}

- (NSString *)getDirectoryPathOfFolderInDocumentsDirectory:(NSString *)folderName {
    
    return [self getDirectoryPathFromDirectories:@[folderName] isBaseOnDocuments:YES];
}

- (NSString *)getDirectoryPathFromDirectories:(NSArray *)directoryList {
    
    return [self getDirectoryPathFromDirectories:directoryList isBaseOnDocuments:YES];
}

- (NSString *)getDirectoryPathFromDirectories:(NSArray *)directoryList isBaseOnDocuments:(BOOL)isInDocumentsFolder {
    
    NSString *homeDir = NSHomeDirectory();
    if (isInDocumentsFolder) {
        homeDir = [homeDir stringByAppendingPathComponent:@"Documents"];
    }
    
    NSString *targetPath = [homeDir copy];
    for (int i = 0; i < directoryList.count; i++) {
        NSString *dirName = directoryList[i];
        targetPath = [targetPath stringByAppendingPathComponent:dirName];
    }
    
    if (![self.fileManager fileExistsAtPath:targetPath]) {
        [self.fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return targetPath;
}

- (BOOL)saveFile:(NSData *)fData toPath:(NSString *)filePath {
    
    BOOL result = [self.fileManager createFileAtPath:filePath contents:fData attributes:nil];
    
    return result;
}

- (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    
    return [self.fileManager moveItemAtPath:fromPath toPath:toPath error:nil];
}

#pragma mark - Feature

- (BFFileType)checkFileType:(NSString *)fileName {
    
    BFFileType fileType = BFFileTypeUnknown;
    
    // 方法一
//    if ([fileName hasSuffix:@".jpg"] || [fileName hasSuffix:@".png"]) {
//        fileType = BFFileTypePhoto;
//    } else if ([fileName hasSuffix:@".mov"] || [fileName hasSuffix:@".mp4"]) {
//        fileType = BFFileTypeVideo;
//    }
    
    // 方法二
    if (BFFileTypeUnknown == fileType) {    // photo
        NSArray *photoTypies = @[@".jpg", @".png"];
        for (NSString *type in photoTypies) {
            if ([fileName hasSuffix:type]) {
                fileType = BFFileTypePhoto;
                break;
            }
        }
    }
    if (BFFileTypeUnknown == fileType) {    // video
        NSArray *videoTypies = @[@".mov", @".mp4"];
        for (NSString *type in videoTypies) {
            if ([fileName hasSuffix:type]) {
                fileType = BFFileTypeVideo;
                break;
            }
        }
    }
    
    return fileType;
}

#pragma mark - Album

- (void)test {
    
}

@end
