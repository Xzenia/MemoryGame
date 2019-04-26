import Foundation

public class Move
{
    var id: Int
    var name: String
    var type: MoveType
    var description: String
    init(_id: Int, _name: String, _type: MoveType, _description: String){
        id = _id
        name = _name
        type = _type
        description = _description
    }
}

enum MoveType{
    case Offense
    case Defense
    case Healing
}
