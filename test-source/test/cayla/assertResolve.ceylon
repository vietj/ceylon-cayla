import java.util.concurrent { CountDownLatch, TimeUnit }
import ceylon.promise { Promise }

shared T assertResolve<T>(Promise<T> promise) {
  value latch = CountDownLatch(1);
  variable <T|Throwable>? result = null;
  promise.always {
    void callback(T|Throwable r) {
      result = r;
      latch.countDown();
    }
  };
  if (latch.await(20000, TimeUnit.\iMICROSECONDS)) {
    assert(exists r = result);
    if (is Throwable r) {
      throw r;
    } else {
      return r;
    }
  } else {
    throw AssertionError("Time out");
  }
}