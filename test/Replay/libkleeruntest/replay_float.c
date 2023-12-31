// REQUIRES: floating-point
// RUN: %clang %s -emit-llvm -g %O0opt -c -o %t.bc
// RUN: rm -rf %t.klee-out
// RUN: %klee --libc=klee --use-cex-cache=false --output-dir=%t.klee-out --search=dfs %t.bc
// RUN: test -f %t.klee-out/test000001.ktest
// RUN: test -f %t.klee-out/test000002.ktest

// Now try to replay with libkleeRuntest
// RUN: %cc %s %libkleeruntest -Wl,-rpath %libkleeruntestdir -lm -o %t_runner
// RUN: env KTEST_FILE=%t.klee-out/test000001.ktest %t_runner | FileCheck -check-prefix=TESTONE %s
// RUN: env KTEST_FILE=%t.klee-out/test000002.ktest %t_runner | FileCheck -check-prefix=TESTTWO %s

#include "klee/klee.h"
#include <math.h>
#include <stdio.h>

int main() {
  double a, b;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_make_symbolic(&b, sizeof(b), "b");
  if (fmin(a, b) == a) {
    printf("fmin(a, b) == a\n");
  } else {
    printf("fmin(a, b) != a\n");
  }
  return 0;
}

// TESTONE: fmin(a, b) != a
// TESTTWO: fmin(a, b) == a
