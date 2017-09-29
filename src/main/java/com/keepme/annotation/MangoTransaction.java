package com.keepme.annotation;

import java.lang.annotation.*;

/**
 * @author ash
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MangoTransaction {
}
