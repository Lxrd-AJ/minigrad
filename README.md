# MiniGrad: A Swift Package for Applied Linear Algebra

## To Try
- [ ] Using [matplotlib](https://matplotlib.org/stable/) and PythonKit for visualisations

## N-Dimensional Array Representation
* https://numpy.org/doc/stable/reference/arrays.ndarray.html 
* https://uk.mathworks.com/help/matlab/ref/ind2sub.html 
* https://uk.mathworks.com/help/matlab/ref/sub2ind.html
* https://uk.mathworks.com/help/matlab/math/multidimensional-arrays.html
* https://www.pythonlikeyoumeanit.com/Module3_IntroducingNumpy/AccessingDataAlongMultipleDimensions.html

### Slicing
`subscript(slice: [Any]) -> Tensor`
where `slice` should contain either `Range` or `Int`
OR
`subscript(slice: Any...) -> Tensor` https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions/#Variadic-Parameters
