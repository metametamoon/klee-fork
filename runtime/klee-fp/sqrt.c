/*===-- sqrt.c ------------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===*/
#include "klee/klee.h"

double sqrt(double d) { return klee_sqrt_double(d); }

float sqrtf(float f) { return klee_sqrt_float(f); }

#if defined(__x86_64__) || defined(__i386__)
long double sqrtl(long double f) { return klee_sqrt_long_double(f); }
#endif
