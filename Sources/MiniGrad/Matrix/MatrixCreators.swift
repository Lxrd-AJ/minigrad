//
//  MatrixCreators.swift
//
//  Created by AJ Ibraheem on 26/08/2024.
//  Copyright 2024.
   

extension Matrix {
    public static func zeros(nrows: Int, ncols: Int) -> Matrix<Element> {        
        return Matrix(rows: nrows, cols: ncols, initialValue: 0)
    }
    
    public static func diagonal(elements: [Element]) -> Matrix<Element> {
        let n = elements.count
        let mat = Matrix.zeros(nrows: n, ncols: n)
        
        for idx in 0 ..< n {
            mat[idx, idx] = elements[Int(idx)]
        }
        
        return mat
    }
}
