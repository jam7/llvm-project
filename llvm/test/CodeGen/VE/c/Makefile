CLANG = $(HOME)/llvm-dev/build-upstream/bin/clang
LLC = $(HOME)/llvm-dev/build-upstream/bin/llc
CLEAN_TEST = $(HOME)/llvm-dev/llvm-project/llvm/utils/clean-test.sh
UPDATE_LLC_TEST = $(HOME)/llvm-dev/llvm-project/llvm/utils/update_llc_test_checks.py
PATCH_TEST = $(HOME)/llvm-dev/llvm-project/llvm/utils/patch-test.py

TARGETS = select.ll

all: $(TARGETS)

select.ll: select.c
	$(CLANG) -target ve -O3 -S -emit-llvm $?
	$(CLEAN_TEST) $@
	sed -e '1i ; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s' $@ > $@.tmp && mv $@.tmp $@
	$(UPDATE_LLC_TEST) --llc-binary=$(LLC) $@
	$(PATCH_TEST) $@

clean: FORCE
	rm -f $(TARGETS)

FORCE:
