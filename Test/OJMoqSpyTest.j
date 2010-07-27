@import "../Frameworks/OJMoq/OJMoqSpy.j"
@import <OJSpec/OJSpec.j>

@implementation OJMoqSpyTest : OJTestCase

- (void)testThatOJMoqSpyDoesInitialize
{
	[[OJMoqSpy spyOnBaseObject:@"TEST"] shouldNotBeNil];
}

- (void)testThatOJMoqSpyDoesFailWhenSelectorNotCalled
{
	var spy = [OJMoqSpy spyOnBaseObject:@"TEST"];
	
	[spy selector:@selector(capitalizedString) times:1];
	
	[OJAssert assertThrows:function(){[spy verifyThatAllExpectationsHaveBeenMet]}];
}

- (void)testThatOJMoqSpyDoesDetectCallsOnObjects
{
	var target = @"TEST";
	var spy = [OJMoqSpy spyOnBaseObject:target];
	
	[spy selector:@selector(capitalizedString) times:1];
	
	[target capitalizedString];
	
	[spy verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqSpyDoesDetectCallsOnObjectsWithArgumentMatching
{
	var target = @"TEST";
	var spy = [OJMoqSpy spyOnBaseObject:target];
	
	[spy selector:@selector(substringFromIndex:) times:1 arguments:[1]];
	
	[target substringFromIndex:1];
	
	[spy verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqSpyDoesDetectCallsOnObjectsWithArgumentMatching
{
	var target = @"TEST";
	var spy = [OJMoqSpy spyOnBaseObject:target];
	
	[spy selector:@selector(substringFromIndex:) times:0 arguments:[1]];
	
	[target substringFromIndex:2];
	
	[spy verifyThatAllExpectationsHaveBeenMet];
}

@end