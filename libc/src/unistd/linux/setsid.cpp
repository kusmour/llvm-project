//===-- Linux implementation of setsid-------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/unistd/setsid.h"

#include "hdr/types/pid_t.h"
#include "src/__support/OSUtil/syscall.h" // For internal syscall function.
#include "src/__support/common.h"
#include "src/__support/macros/config.h"

#include <sys/syscall.h> // For syscall numbers.

namespace LIBC_NAMESPACE_DECL {

LLVM_LIBC_FUNCTION(pid_t, setsid, ()) {
  return LIBC_NAMESPACE::syscall_impl<pid_t>(SYS_setsid);
}

} // namespace LIBC_NAMESPACE_DECL
