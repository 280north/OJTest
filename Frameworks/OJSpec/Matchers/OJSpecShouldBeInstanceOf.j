@import "../OJSpecMatcher.j"

@implementation OJSpecShouldBeInstanceOf : OJSpecMatcher
{
}

- (BOOL)matches:(id)actual
{
    return [super matches:[actual class]];
}

@end


/**
 * Checks if an object is an instance of the expected class
 */
@implementation CPObject (ShouldBeInstanceOfMatcher)

- (void)shouldBeInstanceOf:(Class)expected
{
    if(![[[OJSpecShouldBeInstanceOf alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

- (void)shouldNotBeInstanceOf:(Class)expected
{
    if([[[OJSpecShouldBeInstanceOf alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

@end
