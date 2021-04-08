(set-option :produce-models true)
(set-logic QF_ABV)
(define-fun |UNROLL#2| () Bool true)
(define-fun |UNROLL#4| () Bool true)
(define-fun |UNROLL#0| () Bool (and |UNROLL#2| |UNROLL#4| ))
(assert |UNROLL#0|)
(declare-fun |UNROLL#6| () Bool)
(declare-fun |UNROLL#7| () Bool)
(declare-fun |UNROLL#8| () Bool)
(declare-fun |UNROLL#11| () (_ BitVec 1))
(declare-fun |UNROLL#12| () (_ BitVec 1))
(define-fun |UNROLL#10| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#11|) #b1) |UNROLL#12| #b0))
(define-fun |UNROLL#9| () Bool (= ((_ extract 0 0) |UNROLL#10|) #b1))
(declare-fun |UNROLL#13| () Bool)
(declare-fun |UNROLL#16| () (_ BitVec 1))
(define-fun |UNROLL#15| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#11|) #b1) |UNROLL#16| #b0))
(define-fun |UNROLL#14| () Bool (= ((_ extract 0 0) |UNROLL#15|) #b1))
(declare-fun |UNROLL#17| () Bool)
(declare-fun |UNROLL#20| () (_ BitVec 1))
(define-fun |UNROLL#19| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#11|) #b1) |UNROLL#20| #b1))
(define-fun |UNROLL#18| () Bool (= ((_ extract 0 0) |UNROLL#19|) #b1))
(declare-fun |UNROLL#21| () Bool)
(declare-fun |UNROLL#24| () (_ BitVec 1))
(define-fun |UNROLL#23| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#11|) #b1) |UNROLL#24| #b0))
(define-fun |UNROLL#22| () Bool (= ((_ extract 0 0) |UNROLL#23|) #b1))
(declare-fun |UNROLL#25| () (_ BitVec 16))
(declare-fun |UNROLL#28| () (_ BitVec 16))
(define-fun |UNROLL#27| () (_ BitVec 16) (ite (= ((_ extract 0 0) |UNROLL#11|) #b1) |UNROLL#28| #b0000000000000000))
(define-fun |UNROLL#26| () (_ BitVec 16) |UNROLL#27|)
(declare-fun |UNROLL#30| () Bool)
(define-fun |UNROLL#29| () Bool |UNROLL#30|)
(declare-fun |UNROLL#31| () (_ BitVec 16))
(declare-fun |UNROLL#33| () (_ BitVec 16))
(define-fun |UNROLL#32| () (_ BitVec 16) |UNROLL#33|)
(declare-fun |UNROLL#34| () Bool)
(declare-fun |UNROLL#36| () Bool)
(define-fun |UNROLL#35| () Bool |UNROLL#36|)
(define-fun |UNROLL#37| () Bool (= ((_ extract 0 0) |UNROLL#11|) #b1))
(declare-fun |UNROLL#38| () Bool)
(declare-fun |UNROLL#40| () Bool)
(define-fun |UNROLL#39| () Bool |UNROLL#40|)
(declare-fun |UNROLL#41| () Bool)
(declare-fun |UNROLL#44| () (_ BitVec 1))
(declare-fun |UNROLL#47| () (_ BitVec 1))
(define-fun |UNROLL#46| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#44|) #b1) #b1 |UNROLL#47|))
(declare-fun |UNROLL#49| () (_ BitVec 1))
(declare-fun |UNROLL#50| () (_ BitVec 16))
(define-fun |UNROLL#48| () (_ BitVec 16) (ite (= ((_ extract 0 0) |UNROLL#49|) #b1) |UNROLL#50| #b0000000000000000))
(declare-fun |UNROLL#53| () (_ BitVec 1))
(define-fun |UNROLL#54| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#44|) #b1) ((_ extract 7 7) |UNROLL#48|) #b0))
(define-fun |UNROLL#52| () (_ BitVec 1) (bvor |UNROLL#53| |UNROLL#54|))
(define-fun |UNROLL#57| () (_ BitVec 1) (bvnot ((_ extract 7 7) |UNROLL#48|)))
(define-fun |UNROLL#56| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#44|) #b1) |UNROLL#57| #b0))
(define-fun |UNROLL#55| () (_ BitVec 1) (bvnot |UNROLL#56|))
(define-fun |UNROLL#51| () (_ BitVec 1) (bvand |UNROLL#52| |UNROLL#55|))
(define-fun |UNROLL#45| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#46|) #b1) ((_ extract 15 15) |UNROLL#48|) |UNROLL#51|))
(define-fun |UNROLL#43| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#44|) #b1) #b0 |UNROLL#45|))
(define-fun |UNROLL#42| () Bool (= ((_ extract 0 0) |UNROLL#43|) #b1))
(declare-fun |UNROLL#58| () Bool)
(declare-fun |UNROLL#61| () (_ BitVec 1))
(define-fun |UNROLL#60| () (_ BitVec 1) (ite (= ((_ extract 0 0) |UNROLL#49|) #b1) |UNROLL#61| #b0))
(define-fun |UNROLL#59| () Bool (= ((_ extract 0 0) |UNROLL#60|) #b1))
(declare-fun |UNROLL#62| () (_ BitVec 16))
(declare-fun |UNROLL#65| () (_ BitVec 16))
(define-fun |UNROLL#64| () (_ BitVec 16) (ite (= ((_ extract 0 0) |UNROLL#49|) #b1) |UNROLL#65| #b0000000000000000))
(define-fun |UNROLL#63| () (_ BitVec 16) |UNROLL#64|)
(declare-fun |UNROLL#66| () Bool)
(declare-fun |UNROLL#68| () Bool)
(define-fun |UNROLL#67| () Bool |UNROLL#68|)
(declare-fun |UNROLL#69| () (_ BitVec 16))
(declare-fun |UNROLL#71| () (_ BitVec 16))
(define-fun |UNROLL#70| () (_ BitVec 16) |UNROLL#71|)
(declare-fun |UNROLL#73| () Bool)
(define-fun |UNROLL#72| () Bool |UNROLL#73|)
(declare-fun |UNROLL#75| () Bool)
(define-fun |UNROLL#74| () Bool |UNROLL#75|)
(define-fun |UNROLL#76| () Bool (= ((_ extract 0 0) |UNROLL#44|) #b1))
(define-fun |UNROLL#77| () Bool (= ((_ extract 0 0) |UNROLL#49|) #b1))
(declare-fun |UNROLL#79| () Bool)
(define-fun |UNROLL#78| () Bool |UNROLL#79|)
(define-fun |UNROLL#80| () Bool true)
(define-fun |UNROLL#81| () Bool true)
(define-fun |UNROLL#5| () Bool (and (= |UNROLL#6| |UNROLL#7|) (= |UNROLL#8| |UNROLL#9|) (= |UNROLL#13| |UNROLL#14|) (= |UNROLL#17| |UNROLL#18|) (= |UNROLL#21| |UNROLL#22|) (= |UNROLL#25| |UNROLL#26|) (= false |UNROLL#29|) (= |UNROLL#31| |UNROLL#32|) (= |UNROLL#34| |UNROLL#35|) (= false |UNROLL#37|) (= |UNROLL#38| |UNROLL#39|) (= |UNROLL#6| |UNROLL#41|) (= |UNROLL#34| |UNROLL#42|) (= |UNROLL#58| |UNROLL#59|) (= |UNROLL#62| |UNROLL#63|) (= |UNROLL#66| |UNROLL#67|) (= |UNROLL#69| |UNROLL#70|) (= |UNROLL#13| |UNROLL#72|) (= |UNROLL#17| |UNROLL#74|) (= true |UNROLL#76|) (= false |UNROLL#77|) (= |UNROLL#38| |UNROLL#78|) |UNROLL#80| |UNROLL#81| ))
(assert |UNROLL#5|)
(assert (not |UNROLL#6|))
(declare-fun |UNROLL#84| () (_ BitVec 1))
(define-fun |UNROLL#83| () Bool (or (= ((_ extract 0 0) |UNROLL#84|) #b1) (not false)))
(define-fun |UNROLL#85| () Bool true)
(define-fun |UNROLL#86| () Bool true)
(define-fun |UNROLL#82| () Bool (and |UNROLL#83| |UNROLL#85| |UNROLL#86| ))
(assert (not (and |UNROLL#82| true)))
; running check-sat..
(set-info :status unsat)
(check-sat)
(exit)
