;; I/O

(define zmq-poll-size (c-sizeof "zmq_pollitem_t"))

(define (make-zmq-pollitem socket event-list)
  (let ((pollitem (malloc zmq-poll-size 'zmq_pollitem_t))
        (events (make-zmq-poll-event event-list)))
    (c->= pollitem "zmq_pollitem_t socket" socket)
    (c->= pollitem "zmq_pollitem_t events" events)
    pollitem))

(define (zmq-pollin? revents)
  (= (modulo revents 2) 1))

(define (zmq-pollout? revents)
  (= (modulo (quotient revents 2) 2) 1))

(define (zmq-pollitem-revents pollitem)
  (c-> pollitem "zmq_pollitem_t revents"))

(define (zmq-pollitem-events pollitem)
  (c-> pollitem "zmq_pollitem_t events"))

(define (zmq-pollitem-socket pollitem)
  (c-> pollitem "zmq_pollitem_t socket"))

(define (zmq-poll items nitems timeout)
  (c-call "zmq_poll" items nitems timeout))

(define (zmq-send socket data)
  (c-call "zmq_send"
	  socket
	  (make-zmq-buffer data)
	  (vector-8b-length data)
	  0))

(define (zmq-send-list socket . messages)
  (for-each
   (lambda (data flag)
     (c-call "zmq_send"
	     socket
	     (make-zmq-buffer data)
	     (vector-8b-length data)
	     flag))
   messages
   (reverse (cons 0 (make-list (- (length messages) 1) 2)))))

(define (zmq-receive socket size)
  (let ((buffer (malloc size 'char)))
    (let ((ret (c-call "zmq_recv" socket buffer size 0)))
      (if (= -1 ret)
	  (error "could not receive message" (get-zmq-error-string))
	  (parse-zmq-buffer buffer size ret)))))

(define zmq-flags
  '((dontwait 1)
    (sndmore 2)))

(define zmq-poll-events
  `((pollin  1)
    (pollout 2)
    (pollerr 4)
    (pollpri 8)))
