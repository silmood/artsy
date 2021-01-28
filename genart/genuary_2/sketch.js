let grid
let ruleset = [0,1,1,1,1,0,0,0]
//let ruleset = [0,1,1,1,1,1,1,0]
//let ruleset = [0,1,1,0,1,1,0,1]
//let ruleset = [0,1,0,1,1,0,1,0]

let speed
const CELL_SIZE = 5
let n

let capturer
let capture = true
let capturing = false
let renderer

function setup() {
  speed = TWO_PI / 320
  renderer = createCanvas(540, 540);
  capturer = new CCapture( { format: 'webm', framerate: 30, verbose: true, quality: 60 } )
  frameRate(30)

  grid = createGrid(4 * width / 5, 4 * width / 5, CELL_SIZE)
  restartGrid(grid)
  _.times(grid.rows * 2, () => generate(grid))

  n = random(10)
}

function draw() {
  background(0);
  _.forEach(grid.cells,
      col => _.forEach(col, cell => {
        drawCell(grid, cell)
        n += 0.00056
      })
  )

  if(capture && !capturing) {
    capturer.start()
    capturer.capture(renderer.canvas)
    capturing = true
  } else if((frameCount * speed) % PI == 0 && capturing){
    capturer.stop()
    capturer.save()
    capturing = false
  }

  capturer.capture(renderer.canvas)
}

function drawCell(grid, cell) {
  push()
  let x = cell.position.x
  let y = cell.position.y
  blendMode(ADD)
  noStroke()

  //let size = (CELL_SIZE * 0.5) + (sin(frameCount * TWO_PI / 320) * CELL_SIZE/8)

  let t = PI / (grid.cols / 12)
  let lx = (cell.index.x * t) + (frameCount * speed)
  let limitX = 255 * pow(sin(lx), 2)
  let sizeX = CELL_SIZE * pow(sin(lx), 2) * 0.8

  let t2 = PI / (grid.cols / 1)
  let ly = (cell.index.y * t2) + (frameCount * speed)
  let limitY = 255 * pow(sin(ly), 2)
  let sizeY = CELL_SIZE * pow(sin(ly), 2) * 0.8

  let limit = max(limitX, limitY)
  let size = max(sizeX, sizeY)

  translate(x, y + (pow(sin(ly), 2) * CELL_SIZE * 2.5))
  rectMode(CENTER)

  if (cell.state) {
    fill(252, 40, 213, limit)
    circle(CELL_SIZE * 0.16, CELL_SIZE * 0.16, size, size)

    fill(0, 242, 252, limit)
    circle(-CELL_SIZE * 0.16, -CELL_SIZE * 0.16, size, size)

  }
  pop()
}

function createGrid(w, h, size) {
  let cols = floor(w / size)
  let rows = floor(h / size)
  let cells = _.times(cols, Array)
  let generation = 0

  return {
    cells,
    cols,
    rows,
    generation
  }
}

function generate(grid) {
  _.times(grid.cols, i => {
    let left = grid.cells[( i + grid.cols-1 ) % grid.cols][grid.generation % grid.rows]
    let me = grid.cells[i][grid.generation % grid.rows]
    let right = grid.cells[(i + 1) % grid.cols][grid.generation % grid.rows]
    let cellState = computeRule(left, me, right)

    grid.cells[i][(grid.generation + 1) % grid.rows].state = cellState
  })

  grid.generation += 1
}

function restartGrid(grid) {
  grid.cells =
    _.map(_.times(grid.cols, Array),
      (col, x) => _.times(grid.rows, y => createCell(x, y))
    )
  
  grid.cells[grid.cols / 2][0].state = 1
  _.times(grid.cols, i => {
    //grid.cells[i][0].state = random(0, 10) >  ? 1 : 0
  })
  grid.generation = 0
}

function createCell(x, y) {
  return {
    index: createVector(x, y),
    position: createVector((x * CELL_SIZE) + (width/10), (y * CELL_SIZE) + (height/10)),
    state: 0
  }
}

function computeRule(left, me, right) {
  let index = parseInt(`${left.state}${me.state}${right.state}`, 2)
  return ruleset[index]
}
