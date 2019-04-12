#import "FullBinaryTrees.h"
#include "math.h"
// good luck
@implementation FullBinaryTrees

- (NSString *)stringForNodeCount:(NSInteger)count {
    if (count % 2 == 0) {
        return @"[]";
    }
    NSMutableArray *nodes = [self arrayOfNodesForCount: count];
    NSMutableArray *trees = [NSMutableArray new];
    for (NSArray *tree in nodes) {
        [trees addObject: [NSString stringWithFormat:@"[%@]", [tree componentsJoinedByString:@","]]];
    }
    NSString *result = [NSString stringWithFormat:@"[%@]", [trees componentsJoinedByString:@","]];
    [trees release];
    return result;
    // interesting cases to test:
    //
    // NSString *output = [self sanitize:[self.solution stringForNodeCount:17]];
    // XCTAssertTrue([output containsString:@"[0,0,0,0,0,0,0,0,0,null,null,null,null,0,0,0,0,null,null,null,null,0,0,0,0]"]);
    //
    // NSString *output = [self sanitize:[self.solution stringForNodeCount:13]];
    // XCTAssertTrue([output containsString:@"[0,0,0,0,0,0,0,0,0,null,null,null,null,0,0,null,null,null,null,null,null,0,0]"]);
}

- (NSMutableArray *)arrayOfNodesForCount:(NSInteger)count {
    if (count == 1) {
        return [NSMutableArray arrayWithArray: @[@[@"0"]]];
    }
    if (count == 3) {
        return [NSMutableArray arrayWithArray: @[@[@"0", @"0", @"0"]]];
    }
    NSMutableArray *trees = [NSMutableArray new];
    for (int i = 1; i <= (count - 1) / 2; i += 2) { // in a full binary tree all the subtrees are also full binary trees, so we will iterate through all possible pairs of subtrees from root, e.g. for 7: 1+root+5, 3+root+3, 5+root+1
        NSMutableArray *smallerTrees = [self arrayOfNodesForCount: i];
        NSMutableArray *biggerTrees;
        if (i == count - 1 - i) {
            biggerTrees = [NSMutableArray arrayWithArray: smallerTrees];
        } else {
            biggerTrees = [self arrayOfNodesForCount: count - 1 - i];
        }
        for (NSArray *smTree in smallerTrees) {
            for (NSArray *bgTree in biggerTrees) {
                NSArray *tempTree = [self treeWithSubtreesLeft:smTree andRight:bgTree];
                [trees addObject:tempTree];
                if ([bgTree isEqualToArray:smTree]) {
                    continue;
                }
                tempTree = [self treeWithSubtreesLeft:bgTree andRight:smTree];
                [trees addObject:tempTree];
            }
            if (i == count - 1 - i) { // i.e. biggerTrees == smallerTrees, biggerTrees[0] == smTree, so we have already added all the trees with biggerTrees[0] during this iteration
                [biggerTrees removeObjectAtIndex: 0];
            }
        }
    }
    return [trees autorelease];
}

- (NSArray *)treeWithSubtreesLeft:(NSArray *)leftTree andRight:(NSArray *)rightTree {
    NSMutableArray *treeL = [NSMutableArray arrayWithArray: leftTree];
    NSMutableArray *treeR = [NSMutableArray arrayWithArray: rightTree];
    NSMutableArray *fullTree = [NSMutableArray arrayWithObject: @"0"]; // root
    int nodesInLevel = 1; // nodes count in level of full tree
    int index = 0; // starting index of level in subtree
    while (treeL.count != 0 || treeR.count != 0) {
        for (int i = 0; i < nodesInLevel; i++) { // iterate through level in subtree
            if (![fullTree[(index + i + nodesInLevel - 1) / 2] isKindOfClass: [NSNull class]]) { // (index + i + nodesInLevel - 1) / 2 turns index of current node in subtree into index of its parent in full tree
                if ([(NSString *)fullTree[(index + i + nodesInLevel - 1) / 2] isEqualToString: @"0"]) { // current node has value only if its parent in full tree is "0"
                    if (treeL.count == 0) { // left tree has ended
                        [fullTree addObject: @"null"];
                    } else {
                        [fullTree addObject: treeL.firstObject];
                        [treeL removeObjectAtIndex: 0];
                    }
                    continue;
                }
            } // else use NSNull as a placeholder; placeholders in full tree are needed for correct call to parent
            [fullTree addObject: [NSNull null]];
        }
        for (int i = 0; i < nodesInLevel; i++) {
            if (![fullTree[(index + i + 2 * nodesInLevel - 1) / 2] isKindOfClass: [NSNull class]]) {
                if ([(NSString *)fullTree[(index + i + 2 * nodesInLevel - 1) / 2] isEqualToString: @"0"]) { // current node has value only if its parent in full tree is "0"
                    if (treeR.count == 0) { // rigth tree has ended
                        [fullTree addObject: @"null"];
                    } else {
                        [fullTree addObject: treeR.firstObject];
                        [treeR removeObjectAtIndex: 0];
                    }
                    continue;
                }
            } // else use NSNull as a placeholder; placeholders in full tree are needed for correct call to parent
            [fullTree addObject: [NSNull null]];
        }
        index += nodesInLevel;
        nodesInLevel *= 2;
    }
    [fullTree removeObject:[NSNull null]]; // remove all placeholders
    while ([(NSString *)fullTree.lastObject isEqualToString:@"null"]) { // remove all "null" strings in the end
        [fullTree removeLastObject];
    }
    return [[fullTree copy] autorelease];
}

@end
