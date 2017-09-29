package com.keepme.mango;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.jfaster.mango.transaction.Transaction;
import org.jfaster.mango.transaction.TransactionFactory;

/**
 * @author ash
 */
@Aspect
public class MangoTransactionAspect {

    @Pointcut("@annotation(com.keepme.annotation.MangoTransaction)")
    public void limit() {
    }

    @Around("limit()")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        /*if (TransactionSynchronizationManager.inTransaction()) { // 正在事务中，融入到当前事务

            return pjp.proceed();
        }*/

        Transaction tx = TransactionFactory.newTransaction();
        try {
            Object r = pjp.proceed();

            tx.commit();
            return r;
        } catch (Throwable e) {
            tx.rollback();
            throw e;
        }
    }

}
