@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "CPInvocation+Arguments.j"
@import "OJMoqAssert.j"

var DEPRECATED_METHOD = "%@ is deprecated and will be removed in a future release. Please use %@. Thanks!";

// Create a mock object based on a given object.
function moq(baseObject)
{
    if(!baseObject)
    {
        baseObject = nil;
    }
       
	return [OJMoq mockBaseObject:baseObject];
}

/*!
 * A mocking library for Cappuccino applications
 */
@implementation OJMoq : CPObject
{
	CPObject	_baseObject		@accessors(readonly);
	CPArray		selectors;
	CPArray		expectations;
}

/*!
    Creates an OJMoq object based on the base object. If the base object is nil, then a benign
    stub is created. If the base object is non-nil, it creates a spy mock that allows all of
    the messages to go through to the base object.
    
    \param aBaseObject A nil or non-nil base object that will be wrapped by OJMoq
    \returns An instance of OJMoq that wraps the given base object
 */
+ (id)mockBaseObject:(CPObject)aBaseObject
{
	return [[OJMoq alloc] initWithBaseObject:aBaseObject];
}


/*!
   Creates an OJMoq object based on the base object. If the base object is nil, then a benign
   stub is created. If the base object is non-nil, it creates a spy mock that allows all of
   the messages to go through to the base object.
   
   \param aBaseObject A nil or non-nil base object that will be wrapped by OJMoq
   \returns An instance of OJMoq that wraps the given base object
 */
- (id)initWithBaseObject:(CPObject)aBaseObject
{
	if(self = [super init])
	{
		_baseObject = aBaseObject;
		expectations = [[CPArray alloc] init];
		selectors = [[CPArray alloc] init];
	}
	return self;
}

/*!
   **DEPRECATED**
   @param selector The selector which should be called
   @param times The number of times that selector should be called
 */
- (OJMoq)expectSelector:(SEL)selector times:(int)times
{
    CPLog.warn([[CPString alloc] initWithFormat:DEPRECATED_METHOD, @"expectSelector:times:", @"selector:times:"]);
	return [self selector:selector times:times arguments:[CPArray array]];
}

/*!
   **DEPRECATED**
   @param selector The selector which should be called
   @param times The number of times that selector should be called
   @param arguments Arguments for the selector. If an empty array of arguments is passed in, 
        then the selector matches all arguments.
 */
- (OJMoq)expectSelector:(SEL)selector times:(int)times arguments:(CPArray)arguments
{
    CPLog.warn([[CPString alloc] initWithFormat:DEPRECATED_METHOD, @"expectSelector:times:arguments:", @"selector:times:arguments:"]);
    [self selector:selector times:times arguments:[CPArray array]];
}

/*!
   Expect that selector is called times on the base object. The selector here will match all
     arguments.
   @param selector The selector which should be called
   @param times The number of times that selector should be called
 */
- (OJMoq)selector:(SEL)selector times:(CPNumber)times
{
    [self selector:selector times:times arguments:[CPArray array]];
}
 
/*!
   Expect that selector is called times with arguments on the base object. The selector here
     will match the arguments that you pass it. If an empty array is passed then the selector
     will match all arguments!

     @param selector The selector which should be called
     @param times The number of times that selector should be called
     @param arguments Arguments for the selector. If an empty array of arguments is passed in, 
          then the selector matches all arguments.
 */
- (OJMoq)selector:(SEL)selector times:(CPNumber)times arguments:(CPArray)arguments   
{
    var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments] in:selectors];
    if(theSelector)
    {
    	var expectationFunction = function(){[OJMoqAssert selector:theSelector hasBeenCalled:times];};
        [expectations addObject:expectationFunction];
    }
    else
    {
    	var aSelector = [[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:arguments];
    	var expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:times];};
        [expectations addObject:expectationFunction];
    	[selectors addObject:aSelector];
    }
	return self;
}

/*!
   Ensure that selector returns value when selector is called. Selector will match all arguments.
   @param aSelector The selector on the base object that will be called
   @param value The value that the selector should return
 */
- (OJMoq)selector:(SEL)aSelector returns:(CPObject)value
{
	[self selector:aSelector returns:value arguments:[CPArray array]];
}

/*!
   DEPRECATED
   @param aSelector The selector on the base object that will be called
   @param arguments The arguments that must be passed to selector for this to work
   @param value The value that the selector should return
 */
- (OJMoq)selector:(SEL)aSelector withArguments:(CPArray)arguments returns:(CPObject)value
{
    CPLog.warn([[CPString alloc] initWithFormat:DEPRECATED_METHOD, @"selector:withArguments:returns:", @"selector:returns:arguments:"]);
    [self selector:aSelector returns:value arguments:arguments];
}

/*!
   Ensure that the selector, when called with the specified arguments, will return the given
     value. If you pass an empty array of arguments, then the selector will match all calls.
     
     @param aSelector The selector on the base object that will be called
     @param arguments The arguments that must be passed to selector for this to work
     @param value The value that the selector should return
 */
- (OJMoq)selector:(SEL)aSelector returns:(CPObject)value arguments:(CPArray)arguments
{
	var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments] in:selectors];
	if(theSelector)
	{
		[theSelector setReturnValue:value];
	}
	else
	{
		var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments];
		[aNewSelector setReturnValue:value];
		[selectors addObject:aNewSelector];
	}
	
	return self;
}

/*!
   Provides a callback with the parameters that were passed in to the specified selector
   
   @param aSelector The selector on the base object that will be called
   @param aCallback A single-argument function that is passed the array of arguments
 */
- (OJMoq)selector:(SEL)aSelector callback:(Function)aCallback
{
    [self selector:aSelector callback:aCallback arguments:[CPArray array]];
}

/*!
   Provides a callback with the parameters that were passed in to the specified selector and
      match the given arguments

      @param aSelector The selector on the base object that will be called
      @param aCallback A single-argument function that is passed the array of arguments
      @param arguments The arguments that the selector must match
 */
- (OJMoq)selector:(SEL)aSelector callback:(Function)aCallback arguments:(CPArray)arguments
{
    var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments] in:selectors];
    
    if(theSelector)
    {
        [theSelector setCallback:aCallback];
    }
    else
    {
        var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments];
        [aNewSelector setCallback:aCallback];
        [selectors addObject:aNewSelector];
    }
}

/*!
   Verifies all of the expectations that were set on the OJMoq and fails the test if any of
     the expectations fail.
 */
- (OJMoq)verifyThatAllExpectationsHaveBeenMet
{
	for(var i = 0; i < [expectations count]; i++)
	{
		expectations[i]();
	}
	
	return self;
}

// Ignore the following interface unless you know what you are doing! 
// These are here to intercept calls to the underlying object and 
// should be handled automatically.

/*!
   @ignore
 */
- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
	return YES;
}

/* @ignore */
- (void)forwardInvocation:(CPInvocation)anInvocation
{		
	__ojmoq_incrementNumberOfCalls(anInvocation, selectors);
	
	if(_baseObject !== nil)
	{
	    return [anInvocation invokeWithTarget:_baseObject];
	}
	else
	{
		__ojmoq_setReturnValue(anInvocation, selectors);
		__ojmoq_startCallback(anInvocation, selectors);
	}
}

/*!
   @ignore
 */
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) 
            withArguments:[CPArray array]] in:selectors];
}

@end

function __ojmoq_incrementNumberOfCalls(anInvocation, selectors)
{
	var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector])
		withArguments:[anInvocation userArguments]] in:selectors];
	if(theSelector)
	{
		[theSelector call];
	}
	else
	{
		var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
			withArguments:[anInvocation userArguments]];
		[aNewSelector call];
		[selectors addObject:aNewSelector];
	}
}

function __ojmoq_setReturnValue(anInvocation, selectors)
{
	var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
	    withArguments:[anInvocation userArguments]] in:selectors];
	if(theSelector)
	{
		[anInvocation setReturnValue:[theSelector returnValue]];
	}
	else
	{
		[anInvocation setReturnValue:[[CPObject alloc] init]];
	}
}

function __ojmoq_startCallback(anInvocation, selectors)
{
    var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
	    withArguments:[anInvocation userArguments]] in:selectors];
	if(theSelector)
	{
		[theSelector callback]([anInvocation userArguments]);
	}
}