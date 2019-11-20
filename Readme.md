# Prefix AST

The problem statement can be found [here](https://ocw.cs.pub.ro/courses/iocla/teme/tema-1). Basically, I had to implement (in assembly, of course) a way to compute the result of a mathematical expression. Functionality like reading the input, building the syntax tree and freeing the memory were already implemented.

## Table of Contents

- [Prefix AST](#prefix-ast)
  - [Table of Contents](#table-of-contents)
  - [Abstract syntax tree](#abstract-syntax-tree)
  - [Implementation](#implementation)
    - [preorder](#preorder)
    - [atoi](#atoi)
    - [Other things](#other-things)

## Abstract syntax tree

Abstract syntax trees (or simply syntax trees) are data structures used mostly by compilers to represent the structure of a program. By traversing the AST, the compiler generates important metadata used to transform high-level code into assembly code.

For this problem, AST's are used to represent mathematical expressions. The advantage is that we can represent the expression without using paranthesis. So, an expression like 4 / 64 - 2 * (3 + 1) can be represented as

![AST](https://ocw.cs.pub.ro/courses/_media/iocla/teme/ast.png?cache= "AST")

## Implementation

As I previously said, the AST is already implemented. It's equivalent structure in C++ would be :

```cpp
struct Node {
    char *data;
    struct Node* left;
    struct Node* right;
}
```

Every node could either be an operand, so it was guaranteed it would have two children, or a number, when the node was a "leaf".

### preorder

To evaluate the expression (AST) I used a recursive preorder traversal. Starting from the root, check if the current node represents an operator (+,-,*,/). If it's not, just return the value of the number (not before converting it from a string to an actual number). If it does, apply the same algorithm to the left, the right child, and do the operation specified by the operator between the 2 children. Then, return the result.

### atoi

As the numbers were stored as strings, they had to be converted to integers. To do this, simply go through each char. Because the value of the chars from 0 to 9 are from 48 to 57, we need to subtract 48 from the char to get the real value. If "n" is the original number and "c" is the current number, at every step we do `n = n*10 + c`, untill we reach the null character.

### Other things

Whenever I changed a register in a function, he was reverted to his original value before exiting the function. The only exception is `eax`, because it is used for return values.

© 2019 Grama Nicolae, 322CA
