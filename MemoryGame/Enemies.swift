
import SpriteKit

class Enemies {
    public static var vair = Enemy(_enemyName: "Vair", _baseAttackStat: 10, _baseDefenseStat: 8, _maxHealth: 100, _sprite: SKTexture(imageNamed: "vair_0"))
    public static var byr = Enemy(_enemyName: "Byr", _baseAttackStat: 7, _baseDefenseStat: 7, _maxHealth: 80, _sprite: SKTexture(imageNamed:"byr_0"))
    public static var putulu = Enemy(_enemyName: "Putulu", _baseAttackStat: 9, _baseDefenseStat: 15, _maxHealth: 120, _sprite: SKTexture(imageNamed:"putulu_0"))
    public static var khyr = Enemy(_enemyName: "Khyr", _baseAttackStat: 10, _baseDefenseStat: 5, _maxHealth: 90, _sprite: SKTexture(imageNamed:"khyr_0"))

    
}
