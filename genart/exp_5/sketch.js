const CELL_SIZE = 10

let cellGrid

function setup() {
  createCanvas(512, 512);
  cellGrid = createGrid(width, height, CELL_SIZE)
  restartGrid(cellGrid)
  console.log(cellGrid) 
}

function draw() {
  background(220);
  translate(CELL_SIZE / 2, CELL_SIZE / 2)

  _.forEach(cellGrid.cells,
      col => _.forEach(col, cell => {
        calcNextState(cell)
      })
  )

  _.forEach(cellGrid.cells,
      col => _.forEach(col, cell => {
        drawCell(cell)
      })
  )
}

function mousePressed() {
  restartGrid(cellGrid)
}

function createGrid(w, h, size) {
  let cols = floor(width / size)
  let rows = floor(height / size)
  let cells = _.times(cols, Array)

  return {
    cells,
    cols,
    rows
  }
}

function restartGrid(grid) {
  grid.cells =
    _.map(_.times(grid.cols, Array),
      (col, x) => _.times(grid.rows, y => createCell(x, y))
    )
    
  _.forEach(grid.cells, 
    (col, x) => _.forEach(col, (cell, y) => {

      _.forEach([-1, 0, 1], (diffX) => 
        _.forEach([-1, 0, 1], (diffY) => {
          let neighborX = x + diffX > grid.cols - 1 ?
            0 : x + diffX < 0 ? 
            grid.cols - 1: x + diffX

          let neighborY = y + diffY > grid.rows - 1 ?
            0 : y + diffY < 0 ? 
            grid.rows - 1 : y + diffY
          
          if(neighborX !== x || neighborY !== y) {
            addNeighbor(cell, grid.cells[neighborX][neighborY])
          }
        })
      )
    })
  )
}

function createCell(ex, why) {
  let x = ex * CELL_SIZE
  let y = why * CELL_SIZE
  let nextState = random(2) > 1
  let state = nextState

  return {
    position: createVector(x, y),
    nextState,
    state,
    neighbors: []
  }
}

function addNeighbor(cell, cellToAdd) {
  cell.neighbors.push(cellToAdd)
}

function calcNextState(cell) {
  let alive = _.countBy(cell.neighbors, 'state')

  if (cell.state) {
    cell.nextState = alive.true == 2 || alive.true == 3
  } else {
    cell.nextState = alive.true == 3
  }

}

function drawCell(cell) {
  cell.state = cell.nextState
  let color = cell.state ? 0 : 255

  noStroke()
  fill(color)

  ellipse(cell.position.x, cell.position.y, CELL_SIZE, CELL_SIZE)
}