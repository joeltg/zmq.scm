;; I/O

(define zmq-poll-size (c-sizeof "zmq_pollitem_t"))

(define (make-zmq-pollitem socket event-list)
  (let ((pollitem (malloc (c-sizeof "zmq_pollitem_t") 'zmq_pollitem_t))
        (events (make-zmq-poll-event event-list)))
    (c->= pollitem "zmq_pollitem_t socket" socket)
    (c->= pollitem "zmq_pollitem_t events" events)
    pollitem))

(define (zmq-pollitem-revents pollitem)
  (c-> pollitem "zmq_pollitem_t revents"))

(define (zmq-pollitem-events pollitem)
  (c-> pollitem "zmq_pollitem_t events"))

(define (zmq-pollitem-socket pollitem)
  (c-> pollitem "zmq_pollitem_t socket"))

(define (zmq-poll items nitems timeout)
  (c-call "zmq_poll" items nitems timeout))

(define (make-zmq-message-pointer)
  (let ((message (malloc message-size 'zmq_msg_t))
        (pointer (malloc pointer-size '(* zmq_msg_t))))
    (c-poke-pointer pointer message)
    pointer))

(define (zmq-receive socket)
  (let ((message (make-zmq-message-pointer)))
    (zmq-message-init message)
    (zmq-message-receive message socket)
    (c-peek-cstring (zmq-message-data message))))

(define (zmq-send socket data)
  (let ((size (vector-8b-length data)))
    (zmq-socket-send socket data size)))

(define zmq-flags
  '((dontwait 1)
    (sndmore 2)))

(define zmq-poll-events
  `((pollin  1)
    (pollout 2)
    (pollerr 4)
    (pollpri 8)))
