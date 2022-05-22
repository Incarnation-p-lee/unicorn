#ifndef HAVE_DEFINED_TYPE_H
#define HAVE_DEFINED_TYPE_H

#define __x86_32_

#if defined __x86_32_
    typedef unsigned long long uint64;
    typedef unsigned int       uint32;
    typedef signed int         sint32;
    typedef unsigned short     uint16;
    typedef signed short       sint16;
    typedef unsigned char      uint8;
    typedef signed char        sint8;
    typedef unsigned int       ptr_t;
#endif

#endif

