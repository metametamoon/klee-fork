// REQUIRES: geq-llvm-12.0

// RUN: %clang %s -emit-llvm %O0opt -fno-discard-value-names -g -c -o %t.bc
// RUN: %clang %testcomp_defs -emit-llvm -g -c -o %t.testcomp_defs.bc
// RUN: %llvmlink %t.testcomp_defs.bc %t.bc -o %t.bc
// RUN: rm -rf %t.klee-out
// RUN: %klee --strip-unwanted-calls --forward-ticks=0 --delete-dead-loops=false --function-call-reproduce=reach_error --emit-all-errors --execution-mode=bidirectional --write-kqueries --mock-all-externals --external-calls=all --use-forked-solver=false --max-solvers-approx-tree-inc=16 --max-memory=6008 --optimize --skip-not-lazy-initialized --output-dir=%t.klee-out --write-ktests=true  --use-sym-size-alloc=true --cex-cache-validity-cores --symbolic-allocation-threshold=8192 --uninit-memory-test-multiplier=10 --allocate-determ --allocate-determ-size=3072 --allocate-determ-start-address=0x00030000000 --mem-trigger-cof --use-alpha-equivalence=true --track-coverage=all --use-iterative-deepening-search=max-cycles --max-solver-time=10s --max-cycles-before-stuck=15 --only-output-states-covering-new --dump-states-on-halt=all --search=dfs --search=random-state --debug-log=rootpob,backward,conflict,closepob,reached,init %t.bc 2> %t.log
// RUN: FileCheck %s -input-file=%t.log


// This file is part of the SV-Benchmarks collection of verification tasks:
// https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks
//
// SPDX-FileCopyrightText: 2012-2021 The SV-Benchmarks Community
// SPDX-FileCopyrightText: 2012 FBK-ES <https://es.fbk.eu/>
//
// SPDX-License-Identifier: Apache-2.0

extern void abort(void);

extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void __assert_perror_fail (int __errnum, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void __assert (const char *__assertion, const char *__file, int __line)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));

void reach_error() { ((void) sizeof ((0) ? 1 : 0), __extension__ ({ if (0) ; else __assert_fail ("0", "byte_add-1.c", 3, __extension__ __PRETTY_FUNCTION__); })); }

extern unsigned int __VERIFIER_nondet_uint(void);
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: {reach_error();abort();}
  }
  return;
}

extern void __assert_fail (__const char *__assertion, __const char *__file,
      unsigned int __line, __const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void __assert_perror_fail (int __errnum, __const char *__file,
      unsigned int __line,
      __const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void __assert (const char *__assertion, const char *__file, int __line)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));

unsigned int mp_add(unsigned int a, unsigned int b)
{
    unsigned char a0, a1, a2, a3;
    unsigned char b0, b1, b2, b3;
    unsigned char r0, r1, r2, r3;
    unsigned short carry;
    unsigned short partial_sum;
    unsigned int r;
    unsigned char i;
    unsigned char na, nb;
    a0 = a;
    a1 = a >> 8;
    a2 = a >> 16U;
    a3 = a >> 24U;
    b0 = b;
    b1 = b >> 8U;
    b2 = b >> 16U;
    b3 = b >> 24U;
    na = (unsigned char)4;
    if (a3 == (unsigned char)0) {
        na = na - 1;
        if (a2 == (unsigned char)0) {
            na = na - 1;
            if (a1 == (unsigned char)0) {
                na = na - 1;
            }
        }
    }
    nb = (unsigned char)4;
    if (b3 == (unsigned char)0) {
        nb = nb - 1;
        if (b2 == (unsigned char)0) {
            nb = nb - 1;
            if (b1 == (unsigned char)0) {
                nb = nb - 1;
            }
        }
    }
    carry = (unsigned short)0;
    i = (unsigned char)0;
    while ((i < na) || (i < nb) || (carry != (unsigned short)0)) {
        partial_sum = carry;
        carry = (unsigned short)0;
        if (i < na) {
            if (i == (unsigned char)0) { partial_sum = partial_sum + a0; }
            if (i == (unsigned char)1) { partial_sum = partial_sum + a1; }
            if (i == (unsigned char)2) { partial_sum = partial_sum + a2; }
            if (i == (unsigned char)3) { partial_sum = partial_sum + a3; }
        }
        if (i < nb) {
            if (i == (unsigned char)0) { partial_sum = partial_sum + b0; }
            if (i == (unsigned char)1) { partial_sum = partial_sum + b1; }
            if (i == (unsigned char)2) { partial_sum = partial_sum + b2; }
            if (i == (unsigned char)3) { partial_sum = partial_sum + b3; }
        }
        if (partial_sum > ((unsigned char)254)) {
            partial_sum = partial_sum & ((unsigned char)255);
            carry = (unsigned short)1;
        }
        if (i == (unsigned char)0) { r0 = (unsigned char)partial_sum; }
        if (i == (unsigned char)1) { r1 = (unsigned char)partial_sum; }
        if (i == (unsigned char)2) { r2 = (unsigned char)partial_sum; }
        if (i == (unsigned char)3) { r3 = (unsigned char)partial_sum; }

        i = i + (unsigned char)1;
    }

    while (i < (unsigned char)4) {
        if (i == (unsigned char)0) { r0 = (unsigned char)0; }
        if (i == (unsigned char)1) { r1 = (unsigned char)0; }
        if (i == (unsigned char)2) { r2 = (unsigned char)0; }
        if (i == (unsigned char)3) { r3 = (unsigned char)0; }

        i = i + (unsigned char)1;
    }

    r = r0 | (r1 << 8U) | (r2 << 16U) | ((unsigned int)r3 << 24U);

    return r;
}


int main()
{
    unsigned int a, b, r;

    a = __VERIFIER_nondet_uint();
    b = __VERIFIER_nondet_uint();

    r = mp_add(a, b);

    __VERIFIER_assert(r == a + b);

    return 0;
}

// CHECK: TRUE POSITIVE
