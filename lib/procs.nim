
proc precho*(message: string, prepend: string = ">>> ") =
    ## Print a message with a prefix.
    echo prepend & message
