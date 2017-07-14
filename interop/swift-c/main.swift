// main.swift

import CSum

func sum(

var v: [CDouble] = [ 1.0, 2.0, 3.0, 4.0, 5.0 ]
let n = v.count
let ptr = UnsafeMutablePointer<CDouble>(mutating: v)

print(sum(n, v))
