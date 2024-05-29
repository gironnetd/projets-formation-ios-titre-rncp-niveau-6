//
//  Constants.swift
//  CountOnMe
//
//  Created by damien on 15/06/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Constants {
    
    static var titleExpressionIsIncorrect = "C'est pas très logique !!!"
    static var expressionIsIncorrect = "L'expression %@ est incorrect"
    
    static var titleExpressionHaveNotEnoughElement = "Pas Assez d'élèments !!!"
    static var expressionHaveNotEnoughElement = "Il n'y a pas assez d'élèments dans l'expression\n %@"
    
    static var titleExpressionHaveResult = "L'opération a déja un résultat !!!"
    static var expressionHaveResult = "Il y a déjà un signe = dans l'expression\n %@"
    
    static var titleDivisionByZero = "Zéro !!!"
    static var divisionByZeroIsImpossible = "La division par zéro est Impossible\ncomme dans l'expression\n %@"
    
    static var titleCannotAddOperator = "Impossible !!!"
    static var cannotAddOperator = "Vous ne pouvez pas entrer deux opérateurs succèssivement\ncomme dans l'expression\n %@"
    
    static var titleUnknownOperator = "Ce n'est pas un opérateur !!!"
    static var unknownOperator = "L'expression %@ contient un opérateur inconnu"
}
