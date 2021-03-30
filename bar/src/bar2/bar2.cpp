// MathLibrary.cpp : Defines the exported functions for the DLL.
// #include "pch.h" // use stdafx.h in Visual Studio 2017 and earlier

#include "include/bar2.h"

#include <utility>
#include <limits.h>
#include <iostream>

// DLL internal state variables:
static unsigned long long previous_;  // Previous value, if any
static unsigned long long current_;   // Current sequence value
static unsigned index_;               // Current seq. position

// Initialize a Fibonacci relation sequence
// such that F(0) = a, F(1) = b.
// This function must be called before any other function.
void fibonacci2_init(
    const unsigned long long a,
    const unsigned long long b)
{
    index_ = 0;
    current_ = a;
    previous_ = b; // see special case when initialized
}

// Produce the next value in the sequence.
// Returns true on success, false on overflow.
bool fibonacci2_next()
{
    // check to see if we'd overflow result or position
    if ((ULLONG_MAX - previous_ < current_) ||
        (UINT_MAX == index_))
    {
        return false;
    }

    // Special case when index == 0, just return b value
    if (index_ > 0)
    {
        // otherwise, calculate next sequence value
        previous_ += current_;
    }
    std::swap(current_, previous_);
    ++index_;
    return true;
}

// Get the current value in the sequence.
unsigned long long fibonacci2_current()
{
    return current_;
}

// Get the current index position in the sequence.
unsigned fibonacci2_index()
{
    return index_;
}


void bar2_hello() {

    std::cout << "Bar2 Hello World" << std::endl;
}