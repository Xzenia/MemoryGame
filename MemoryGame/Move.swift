import Foundation

public class Move
{
    var id: Int
    var name: String
    var description: String
    
    var attack: Float
    var defense: Float
    
    init(_id: Int, _name: String = "", _description: String = "", _attack: Float, _defense: Float){
        id = _id
        name = _name
        description = _description
        attack = _attack
        defense = _defense
    }
}
