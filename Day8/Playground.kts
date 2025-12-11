import java.io.File
import kotlin.math.pow

val text = File("input").readText()
val list: List<String> = text.lines().filter { it.isNotBlank() }

val pairsWithDistances: MutableList<Triple<Double, Coord, Coord>> = mutableListOf()

for ((i, item) in list.withIndex()) {
    // println(i.toString() + ": " + item)
    for (j in i + 1 until list.size) {
        val pairWithDistance = Triple(Coord(item).distanceTo(Coord(list[j])), Coord(item), Coord(list[j]))
        pairsWithDistances.add(pairWithDistance)
    }
}

val sortedPairsWithDistances = pairsWithDistances.sortedBy { it.first }

var listOfCircuits: MutableList<MutableSet<Coord>> = mutableListOf()

for (i in 0 until 1000) {
    val pairWithDistance = sortedPairsWithDistances[i]
    val coord1 = pairWithDistance.second
    val coord2 = pairWithDistance.third

    var circuit1Index: Int? = null
    var circuit2Index: Int? = null

    for ((index, circuit) in listOfCircuits.withIndex()) {
        if (coord1 in circuit) circuit1Index = index
        if (coord2 in circuit) circuit2Index = index
    }

    when {
        circuit1Index != null && circuit1Index == circuit2Index -> { }

        circuit1Index != null && circuit2Index != null -> {
            listOfCircuits[circuit1Index].addAll(listOfCircuits[circuit2Index])
            listOfCircuits.removeAt(circuit2Index)
        }

        circuit1Index != null -> {
            listOfCircuits[circuit1Index].add(coord2)
        }

        circuit2Index != null -> {
            listOfCircuits[circuit2Index].add(coord1)
        }

        else -> {
            listOfCircuits.add(mutableSetOf(coord1, coord2))
        }
    }
}

val sortedBySize = listOfCircuits.sortedByDescending { it.size }
val topThree = sortedBySize.take(3)
val result = topThree.map { it.size }.reduce { acc, size -> acc * size }

println("Results: $result")

class Coord(val rawText: String) {
    val x: Int
    val y: Int
    val z: Int

    init {
        val parts = rawText.split(",")
        x = parts[0].trim().toInt()
        y = parts[1].trim().toInt()
        z = parts[2].trim().toInt()
    }

    fun distanceTo(other: Coord): Double {
        return Math.sqrt((x - other.x).toDouble().pow(2) + (y - other.y).toDouble().pow(2) + (z - other.z).toDouble().pow(2))
    }

    override fun equals(other: Any?): Boolean {
        if (other !is Coord) return false
        return x == other.x && y == other.y && z == other.z
    }

    override fun hashCode(): Int {
        return x * 31 * 31 + y * 31 + z
    }
}
