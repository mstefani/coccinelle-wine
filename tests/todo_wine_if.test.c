void test(void)
{
    if (sizeof(void*) > sizeof(LONG))
        (todo_wine) ok(foobar(), "foobar failed!\n");
    else
        ok(foobar(), "foobar failed!\n");

    if (sizeof(void*) > sizeof(LONG))
        ok(barfoo(), "barfoo failed!\n");
    else
        (todo_wine) ok(barfoo(), "barfoo failed!\n");
}
