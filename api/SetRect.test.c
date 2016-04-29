void foo(void)
{
    RECT r;
    SetRect(&r, 0, 0, r.left, 0);
    SetRect(&r, 0, 0, 0, r.top);
    SetRect(&r, 0, 0, r.left + 1, 0);
    SetRect(&r, 0, 0, 0, r.top + 1);
}
