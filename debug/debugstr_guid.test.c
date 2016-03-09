void foo(void)
{
    GUID *guid;

    TRACE("%08x-%04x-%04x-%02x%2x-%02x%2x%02x%2x%02x%2x", guid.Data1, guid.Data2, guid.Data3,
            guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3], guid.Data4[4], guid.Data4[5],
            guid.Data4[6], guid.Data4[7]);
    FIXME_(bar)("%08x-%04x-%04x-%02x%2x-%02x%2x%02x%2x%02x%2x", guid.Data1, guid.Data2, guid.Data3,
            guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3], guid.Data4[4], guid.Data4[5],
            guid.Data4[6], guid.Data4[7]);
}
