const input =
	require('fs')
	.readFileSync('ej9.input', 'utf8')
	.split('\n')
	.filter(line => line !== '')
	.map(line => line.split(' '))
	.map(([a, b]) => [a, Number(b)])

class Point {
	constructor() {
		this.x = 0
		this.y = 0
	}
	toString() {
		return `${this.x};${this.y}`
	}
}
const rope = [
	new Point, new Point, new Point, new Point, new Point,
	new Point, new Point, new Point, new Point, new Point
]
const head = rope[0]
const ex1_tail = rope[1]
const ex2_tail = rope[9]
const ex1_visited = new Set
const ex2_visited = new Set
ex1_visited.add(ex1_tail.toString())
ex2_visited.add(ex2_tail.toString())

const directions = {
	R: p => p.x += 1,
	L: p => p.x -= 1,
	U: p => p.y -= 1,
	D: p => p.y += 1,
}
const fix_tail = (head, tail) => {
	const dx = head.x - tail.x
	const dy = head.y - tail.y
	if (1 < Math.abs(dx) || 1 < Math.abs(dy)) {
		tail.x += Math.sign(dx)
		tail.y += Math.sign(dy)
	}
}

for (const [direction, amount] of input) {
	for (let i = 0; i < amount; i++) {
		directions[direction](head)
		rope.reduce((head, tail) => (fix_tail(head, tail), tail))
		ex1_visited.add(ex1_tail.toString())
		ex2_visited.add(ex2_tail.toString())
	}
}

console.log('Ex1', ex1_visited.size)
console.log('Ex2', ex2_visited.size)
