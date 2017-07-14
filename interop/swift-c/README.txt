Compile the C routine into a library:

```
% clang -c sum.c
% ar rcs libsum.a sum.o
```

You could, of course, call `sum` from a C program by linking against the `libsum.a` library as usual:

```
% clang -o main main.c libsum.a
% ./main
```

Writing an appropriate `module.map` file, we can also import the `sum` function from `libsum` and use it in a Swift program:

``` Swift
```


Compiling and linking against `libsum.a`:

```
% swiftc -I. -L. -o main main.swift
```
