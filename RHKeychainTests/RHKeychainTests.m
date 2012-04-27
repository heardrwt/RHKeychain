//
//  RHKeychainTests.m
//  RHKeychainTests
//
//  Created by Richard Heard on 27/04/12.
//  Copyright (c) 2012 Richard Heard. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <RHKeychain/RHKeychain.h>
#import "RHKeychainTests.h"

@implementation RHKeychainTests

- (void)setUp{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testGenericEntry{
    NSString *serviceName = @"RHKeychainGenericEntryTestServiceName";
    NSString *username = @"uname";
    NSString *password = @"pword";
    NSString *comment = @"comnt";
    NSString *username2 = @"uname2";
    NSString *password2 = @"pword2";
    NSString *comment2 = @"comnt2";
    

    //cleanup from any failed runs
    while (RHKeychainDoesGenericEntryExist(NULL, serviceName)){
        RHKeychainRemoveGenericEntry(NULL, serviceName);
    }
    
    
    STAssertFalse(RHKeychainDoesGenericEntryExist(NULL, serviceName), @"entry should not exist pre addition");
    
    STAssertNil(RHKeychainGetGenericUsername(NULL, serviceName), @"username should be nil pre addition");
    STAssertNil(RHKeychainGetGenericPassword(NULL, serviceName), @"password should be nil pre addition");
    STAssertNil(RHKeychainGetGenericComment(NULL, serviceName), @"comment should be nil pre addition");
    
    STAssertFalse(RHKeychainSetGenericUsername(NULL, serviceName, username), @"set username should return false pre addition");
    STAssertFalse(RHKeychainSetGenericPassword(NULL, serviceName, password), @"set password should return false pre addition");
    STAssertFalse(RHKeychainSetGenericComment(NULL, serviceName, comment), @"set comment should return false pre addition");

    STAssertNil(RHKeychainGetGenericUsername(NULL, serviceName), @"username should be nil pre addition");
    STAssertNil(RHKeychainGetGenericPassword(NULL, serviceName), @"password should be nil pre addition");
    STAssertNil(RHKeychainGetGenericComment(NULL, serviceName), @"comment should be nil pre addition");
    
    //add
    STAssertTrue(RHKeychainAddGenericEntry(NULL, serviceName),@"AddEntry should return true");
    STAssertTrue(RHKeychainDoesGenericEntryExist(NULL, serviceName), @"entry should exist post addition");

    //test pre setting
    STAssertNil(RHKeychainGetGenericUsername(NULL, serviceName), @"username should be nil pre setting");
    STAssertNil(RHKeychainGetGenericPassword(NULL, serviceName), @"password should be nil pre setting");
    STAssertNil(RHKeychainGetGenericComment(NULL, serviceName), @"comment should be nil pre setting");

    //set
    STAssertTrue(RHKeychainSetGenericUsername(NULL, serviceName, username), @"set username should return true");
    STAssertTrue(RHKeychainSetGenericPassword(NULL, serviceName, password), @"set password should return true");
    STAssertTrue(RHKeychainSetGenericComment(NULL, serviceName, comment), @"set comment should return true");

    STAssertTrue(RHKeychainDoesGenericEntryExist(NULL, serviceName), @"entry should exist post addition");

    //query for newly set strings
    STAssertTrue([username isEqualToString:RHKeychainGetGenericUsername(NULL, serviceName)], @"username should match preset value");
    STAssertTrue([password isEqualToString:RHKeychainGetGenericPassword(NULL, serviceName)], @"password should match preset value");
    STAssertTrue([comment isEqualToString:RHKeychainGetGenericComment(NULL, serviceName)], @"comment should match preset value");

    //make sure updating them works
    STAssertTrue(RHKeychainSetGenericUsername(NULL, serviceName, username2), @"set username should return true");
    STAssertTrue(RHKeychainSetGenericPassword(NULL, serviceName, password2), @"set password should return true");
    STAssertTrue(RHKeychainSetGenericComment(NULL, serviceName, comment2), @"set comment should return true");

    //query for newly set strings
    STAssertTrue([username2 isEqualToString:RHKeychainGetGenericUsername(NULL, serviceName)], @"username should match preset value");
    STAssertTrue([password2 isEqualToString:RHKeychainGetGenericPassword(NULL, serviceName)], @"password should match preset value");
    STAssertTrue([comment2 isEqualToString:RHKeychainGetGenericComment(NULL, serviceName)], @"comment should match preset value");
    
    //make sure setting to nil works (causing a removal of the field)
    STAssertTrue(RHKeychainSetGenericUsername(NULL, serviceName, nil), @"set username should return true");
    STAssertTrue(RHKeychainSetGenericPassword(NULL, serviceName, nil), @"set password should return true");
    STAssertTrue(RHKeychainSetGenericComment(NULL, serviceName, nil), @"set comment should return true");
    
    //test 
    STAssertNil(RHKeychainGetGenericUsername(NULL, serviceName), @"username should be nil post setting to nil");
    STAssertNil(RHKeychainGetGenericPassword(NULL, serviceName), @"password should be nil post setting to nil");
    STAssertNil(RHKeychainGetGenericComment(NULL, serviceName), @"comment should be nil post setting to nil");

    //test removing
    STAssertTrue(RHKeychainRemoveGenericEntry(NULL, serviceName), @"remove generic entry should return true");
    STAssertFalse(RHKeychainDoesGenericEntryExist(NULL, serviceName), @"entry should no longer exist");

    STAssertNil(RHKeychainGetGenericUsername(NULL, serviceName), @"username should be nil post removal");
    STAssertNil(RHKeychainGetGenericPassword(NULL, serviceName), @"password should be nil post removal");
    STAssertNil(RHKeychainGetGenericComment(NULL, serviceName), @"comment should be nil post removal");

    //done
    
    
}

@end
