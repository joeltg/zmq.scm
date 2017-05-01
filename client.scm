(load "zmq")

(define context (make-zmq-context))
(define socket (make-zmq-socket context 'req))

(zmq-socket-connect socket endpoint)

(define pollitem (make-zmq-pollitem socket '(pollout pollin)))

(define (check)
  (zmq-poll pollitem 1 0)
  (zmq-pollitem-revents pollitem))
