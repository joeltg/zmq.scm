;; Messages

(define (make-zmq-message #!optional size)
  (let ((message (make-alien 'zmq_msg_t)) (init (default-object? size)))
    (let ((ret (if init (c-call "zmq_msg_init" message) (c-call "zmq_msg_init_size" message size))))
      (if (or (alien-null? message) (= -1 ret))
        (error "could not initialize message" (get-zmq-error-string))
        message))))

(define (zmq-message-send message socket #!optional flags)
  (if (= -1 (c-call "zmq_msg_send" message socket (get-zmq-flags flags)))
    (error "could not send message" (get-zmq-error-string))))

(define (zmq-message-receive message socket #!optional flags)
  (if (= -1 (c-call "zmq_msg_recv" message socket (get-zmq-flags flags)))
    (error "could not receive message" (get-zmq-error-string))))

(define (zmq-message-close message)
  (if (= -1 (c-call "zmq_msg_close" message))
    (error "could not close message" (get-zmq-error-string))))

(define (zmq-message-move dest src)
  (if (= -1 (c-call "zmq_msg_move" dest src))
    (error "could not move message" (get-zmq-error-string))))

(define (zmq-message-copy dest src)
  (if (= -1 (c-call "zmq_msg_copy" dest src))
    (error "could not copy message" (get-zmq-error-string))))

(define (zmq-message-data message)
  (c-call "zmq_msg_data" message))

(define (zmq-message-more? message)
  (= 1 (c-call "zmq_msg_more" message)))

(define (zmq-message-size message)
  (c-call "zmq_msg_size" message))

(define (zmq-message-property message property)
  (let ((ret (c-call "zmq_msg_get" message ((zmq-ref zmq-message-properties) property))))
    (if (= -1 ret)
      (error "could not get message property" (get-zmq-error-string))
      ret)))

(define (set-zmq-message-property! message property value)
  (if
    (= -1
      (c-call "zmq_msg_set"
        message
        ((zmq-ref zmq-message-properties) property)
        value))
    (error "could not set message property")))

(define (zmq-message-gets message property-string)
  (let ((ret (c-call "zmq_msg_gets" message property-string)))
    (if (= -1 ret)
      (error "could not get message property string" (get-zmq-error-string))
      ret)))

(define zmq-message-properties
  '((more 1)
    (srcfd 2)
    (shared 3)))
