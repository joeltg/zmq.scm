(load "zmq")

(define context (make-zmq-context))
(define socket (make-zmq-socket context 'rep))

(zmq-socket-bind socket endpoint)

(pp (list "rcvtimeo" (zmq-socket-option socket 'rcvtimeo)))
(pp (list "rcvmore" (zmq-socket-option socket 'rcvmore)))
(define v (malloc 4 '(const int)))
(c->= v "int" -1)
(define s (malloc 4 'size_t))
(c->= s "size_t" 4)

(pp (c-call "zmq_setsockopt" socket 27 v 4))

#|
(define pollitem (make-zmq-pollitem socket '(pollout pollin)))

(define (check)
  (pp "checking")
  (zmq-poll pollitem 1 0)
  (pp "polled successfully")
  (zmq-pollitem-revents pollitem))
|#
