
import SpriteKit

class Enemies {
    public static var vair = Enemy(_enemyName: "vair", _baseAttackStat: 10, _baseDefenseStat: 8, _maxHealth: 100, _idleAnimationFrames: 9, _deathAnimationFrames: 5)
    public static var byr = Enemy(_enemyName: "byr", _baseAttackStat: 7, _baseDefenseStat: 7, _maxHealth: 80, _idleAnimationFrames: 5, _deathAnimationFrames: 6)
    public static var putulu = Enemy(_enemyName: "putulu", _baseAttackStat: 9, _baseDefenseStat: 15, _maxHealth: 120, _idleAnimationFrames: 4, _deathAnimationFrames: 7)
    public static var khyr = Enemy(_enemyName: "khyr", _baseAttackStat: 10, _baseDefenseStat: 5, _maxHealth: 90, _idleAnimationFrames: 3, _deathAnimationFrames: 6)

}
