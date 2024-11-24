	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0"
	.file	"conv.c"
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	zero, -12(s0)
	addi	a0, zero, 2
	sw	a0, -16(s0)
	sw	zero, -20(s0)
	j	.LBB0_1
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	addi	a1, zero, 29
	blt	a1, a0, .LBB0_4
	j	.LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	lui	a1, %hi(in)
	addi	a1, a1, %lo(in)
	slli	a0, a0, 2
	add	a0, a0, a1
	addi	a1, zero, 3
	sw	a1, 0(a0)
	j	.LBB0_3
.LBB0_3:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_1
.LBB0_4:                                # %for.end
	sw	zero, -20(s0)
	j	.LBB0_5
.LBB0_5:                                # %for.cond1
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	addi	a1, zero, 9
	blt	a1, a0, .LBB0_8
	j	.LBB0_6
.LBB0_6:                                # %for.body3
                                        #   in Loop: Header=BB0_5 Depth=1
	lw	a0, -20(s0)
	lui	a1, %hi(wgt)
	addi	a1, a1, %lo(wgt)
	slli	a0, a0, 2
	add	a0, a0, a1
	addi	a1, zero, 2
	sw	a1, 0(a0)
	j	.LBB0_7
.LBB0_7:                                # %for.inc5
                                        #   in Loop: Header=BB0_5 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_5
.LBB0_8:                                # %for.end7
	sw	zero, -20(s0)
	j	.LBB0_9
.LBB0_9:                                # %for.cond8
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	addi	a1, zero, 99
	blt	a1, a0, .LBB0_12
	j	.LBB0_10
.LBB0_10:                               # %for.body10
                                        #   in Loop: Header=BB0_9 Depth=1
	lw	a0, -20(s0)
	lui	a1, %hi(out)
	addi	a1, a1, %lo(out)
	slli	a0, a0, 2
	add	a0, a0, a1
	sw	zero, 0(a0)
	j	.LBB0_11
.LBB0_11:                               # %for.inc12
                                        #   in Loop: Header=BB0_9 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_9
.LBB0_12:                               # %for.end14
	lw	a0, -16(s0)
	call	conv
	mv	a0, zero
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.globl	conv                            # -- Begin function conv
	.p2align	2
	.type	conv,@function
conv:                                   # @conv
# %bb.0:                                # %entry
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	zero, -16(s0)
	sw	zero, -20(s0)
	sw	zero, -16(s0)
	j	.LBB1_1
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	lw	a0, -16(s0)
	addi	a1, zero, 29
	blt	a1, a0, .LBB1_8
	j	.LBB1_2
.LBB1_2:                                # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	sw	zero, -20(s0)
	j	.LBB1_3
.LBB1_3:                                # %for.cond1
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, -20(s0)
	addi	a1, zero, 9
	blt	a1, a0, .LBB1_6
	j	.LBB1_4
.LBB1_4:                                # %for.body3
                                        #   in Loop: Header=BB1_3 Depth=2
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	add	a2, a0, a1
	slli	a2, a2, 2
	lui	a3, %hi(in)
	addi	a3, a3, %lo(in)
	add	a2, a2, a3
	lw	a2, 0(a2)
	lui	a3, %hi(wgt)
	addi	a3, a3, %lo(wgt)
	slli	a1, a1, 2
	add	a1, a1, a3
	lw	a1, 0(a1)
	lui	a3, %hi(out)
	addi	a3, a3, %lo(out)
	slli	a0, a0, 2
	add	a0, a0, a3
	lw	a3, 0(a0)
	imad	a1, a2, a1, a3
	sw	a1, 0(a0)
	j	.LBB1_5
.LBB1_5:                                # %for.inc
                                        #   in Loop: Header=BB1_3 Depth=2
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB1_3
.LBB1_6:                                # %for.end
                                        #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	lui	a2, %hi(out)
	addi	a2, a2, %lo(out)
	slli	a1, a1, 2
	add	a1, a1, a2
	lw	a2, 0(a1)
	add	a0, a2, a0
	sw	a0, 0(a1)
	j	.LBB1_7
.LBB1_7:                                # %for.inc10
                                        #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB1_1
.LBB1_8:                                # %for.end12
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	conv, .Lfunc_end1-conv
                                        # -- End function
	.globl	loop_test                       # -- Begin function loop_test
	.p2align	2
	.type	loop_test,@function
loop_test:                              # @loop_test
# %bb.0:                                # %entry
	addi	sp, sp, -288
	sw	ra, 284(sp)                     # 4-byte Folded Spill
	sw	s0, 280(sp)                     # 4-byte Folded Spill
	addi	s0, sp, 288
	sw	a0, -12(s0)
	addi	a0, zero, 1
	sw	a0, -16(s0)
	sw	zero, -276(s0)
	j	.LBB2_1
.LBB2_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -276(s0)
	addi	a1, zero, 63
	blt	a1, a0, .LBB2_4
	j	.LBB2_2
.LBB2_2:                                # %for.body
                                        #   in Loop: Header=BB2_1 Depth=1
	lw	a0, -276(s0)
	slli	a0, a0, 2
	addi	a1, s0, -272
	add	a0, a1, a0
	addi	a1, zero, 10
	sw	a1, 0(a0)
	j	.LBB2_3
.LBB2_3:                                # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	lw	a0, -276(s0)
	addi	a0, a0, 1
	sw	a0, -276(s0)
	j	.LBB2_1
.LBB2_4:                                # %for.end
	sw	zero, -280(s0)
	j	.LBB2_5
.LBB2_5:                                # %for.cond2
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -280(s0)
	addi	a1, zero, 63
	blt	a1, a0, .LBB2_8
	j	.LBB2_6
.LBB2_6:                                # %for.body4
                                        #   in Loop: Header=BB2_5 Depth=1
	lw	a0, -16(s0)
	lw	a1, -280(s0)
	slli	a1, a1, 2
	addi	a2, s0, -272
	add	a1, a2, a1
	lw	a1, 0(a1)
	lw	a2, -12(s0)
	imad	a0, a0, a1, a2
	sw	a0, -16(s0)
	j	.LBB2_7
.LBB2_7:                                # %for.inc7
                                        #   in Loop: Header=BB2_5 Depth=1
	lw	a0, -280(s0)
	addi	a0, a0, 1
	sw	a0, -280(s0)
	j	.LBB2_5
.LBB2_8:                                # %for.end9
	lw	a0, -16(s0)
	lw	s0, 280(sp)                     # 4-byte Folded Reload
	lw	ra, 284(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 288
	ret
.Lfunc_end2:
	.size	loop_test, .Lfunc_end2-loop_test
                                        # -- End function
	.type	in,@object                      # @in
	.bss
	.globl	in
	.p2align	2
in:
	.zero	120
	.size	in, 120

	.type	wgt,@object                     # @wgt
	.globl	wgt
	.p2align	2
wgt:
	.zero	40
	.size	wgt, 40

	.type	out,@object                     # @out
	.globl	out
	.p2align	2
out:
	.zero	400
	.size	out, 400

	.ident	"clang version 14.0.0 (https://github.com/llvm/llvm-project.git a45d72e0247d080eb9437736bb6cadfc27e4c065)"
	.section	".note.GNU-stack","",@progbits
