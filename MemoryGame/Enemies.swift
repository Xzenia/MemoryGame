
import SpriteKit

class Enemies {
    public static var vair = Enemy(_enemyName: "vair", _baseAttackStat: 10, _baseDefenseStat: 8, _maxHealth: 100, _idleAnimationFrames: 9, _deathAnimationFrames: 5)
    public static var byr = Enemy(_enemyName: "byr", _baseAttackStat: 7, _baseDefenseStat: 7, _maxHealth: 80, _idleAnimationFrames: 5, _deathAnimationFrames: 6)
    public static var putulu = Enemy(_enemyName: "putulu", _baseAttackStat: 9, _baseDefenseStat: 15, _maxHealth: 120, _idleAnimationFrames: 4, _deathAnimationFrames: 7)
    public static var khyr = Enemy(_enemyName: "khyr", _baseAttackStat: 10, _baseDefenseStat: 5, _maxHealth: 90, _idleAnimationFrames: 3, _deathAnimationFrames: 6)
    
    public static var duwende = Enemy(_enemyName: "duwende", _baseAttackStat: 12, _baseDefenseStat: 9, _maxHealth: 110, _idleAnimationFrames: 8, _deathAnimationFrames: 8)
    public static var kapre = Enemy(_enemyName: "kapre", _baseAttackStat: 20, _baseDefenseStat: 10, _maxHealth: 120, _idleAnimationFrames: 13, _deathAnimationFrames: 5)
    public static var manananggal = Enemy(_enemyName: "manananggal", _baseAttackStat: 17, _baseDefenseStat: 25, _maxHealth: 150, _idleAnimationFrames: 2, _deathAnimationFrames: 5)
    public static var polymorph = Enemy(_enemyName: "polymorph", _baseAttackStat: 12, _baseDefenseStat: 20, _maxHealth: 100, _idleAnimationFrames: 5, _deathAnimationFrames: 7)
    public static var prysm = Enemy(_enemyName: "prysm", _baseAttackStat: 10, _baseDefenseStat: 8, _maxHealth: 80, _idleAnimationFrames: 4, _deathAnimationFrames: 8)
    public static var spark = Enemy(_enemyName: "spark", _baseAttackStat: 15, _baseDefenseStat: 10, _maxHealth: 100, _idleAnimationFrames: 15, _deathAnimationFrames: 20)
    
    public static var spyr = Enemy(_enemyName: "spyr", _baseAttackStat: 8, _baseDefenseStat: 10, _maxHealth: 50, _idleAnimationFrames: 5, _deathAnimationFrames: 10)
    public static var tikbalang = Enemy(_enemyName: "tikbalang", _baseAttackStat: 30, _baseDefenseStat: 20, _maxHealth: 200, _idleAnimationFrames: 8, _deathAnimationFrames: 7)
    public static var kyub = Enemy(_enemyName: "kyub", _baseAttackStat: 10, _baseDefenseStat: 8, _maxHealth: 120, _idleAnimationFrames: 6, _deathAnimationFrames: 10)
    public static var kown = Enemy(_enemyName: "kown", _baseAttackStat: 8, _baseDefenseStat: 10, _maxHealth: 70, _idleAnimationFrames: 5, _deathAnimationFrames: 8)
    public static var tsanak = Enemy(_enemyName: "tsanak", _baseAttackStat: 6, _baseDefenseStat: 6, _maxHealth: 90, _idleAnimationFrames: 7, _deathAnimationFrames: 8)

    public static var enemyList = [Enemy]()
    

}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
