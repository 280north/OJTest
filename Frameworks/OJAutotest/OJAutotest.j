@import "../OJUnit/OJTestRunnerText.j"
OS = require("os");
SYSTEM = require("system");

@implementation OJAutotest : OJTestRunnerText
{
    CPArray         testsAlreadyRun;
    CPDate          lastRunTime;
}

+ (void)start
{
    [[[self alloc] init] start];
}

- (void)start
{
    [self runTests];
    
    print("---------- STARTING LOOP ----------");
    print("In order to stop the tests, do Control-C in quick succession.");
    
    [self loop];
}

- (void)loop
{
    print("---------- WAITING FOR CHANGES ----------");
    OS.system("ojautotest-wait Test");
    print("----------  CHANGES  DETECTED  ----------");
    
    OS.sleep(1);
    
    [self runTests];
    
    [self loop];
}

- (void)runTests
{
    [self startWithArguments:[self files]];
    [self testsWereRun];
}

- (CPArray)files
{
    return new (require("jake").FileList)(@"Test/*.j");
}

- (void)testsWereRun
{
    lastRunTime = [CPDate dateWithTimeIntervalSinceNow:0];
}

- (CPString)nextTest:(CPArray)arguments
{
    if(arguments.length == 0)
        return "";
    
    var nextTest = require("file").absolute(arguments.shift());
    
    if([self testHasBeenModified:nextTest])
        return [self nextTest:arguments];
    
    return nextTest;
}

- (BOOL)testHasBeenModified:(CPString)test
{
    var lastModification = require("file").mtime(test);
    return [lastModification compare:lastRunTime] < 0;
}

- (void)exit
{
    // do nothing
}

@end