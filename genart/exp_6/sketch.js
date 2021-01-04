let vortex

function setup() {
  createCanvas(512, 512)
  vortex = createVortex()
}

function draw() {
  background(0)
  drawVortex(vortex)
}

function createVortex() {
  let deepness = 10
  let minSize = 100
  let sizeNoise = random(10)
  let offsetMultiplierX = 0.5
  let offsetMultiplierY = 0.5

  let layers = _.times(deepness, layer => {
    return {
      size: map(layer, 0, deepness, minSize, width),
      offsetX: (width - layer.size) * offsetMultiplierX,
      offsetY: (height - layer.size) * offsetMultiplierY
    }
  })

  return {
    originalMinSize: minSize,
    minSize,
    deepness,
    layers,
    sizeNoise,
    offsetMultiplierX,
    offsetMultiplierY
  }
}


function drawVortex(vortex) {
  updateVortex(vortex)

  _.forEach(vortex.layers, drawLayer)
  drawGrid(vortex)
  drawLayer({ 
    size: vortex.minSize, 
    offsetX: (width - vortex.minSize) * vortex.offsetMultiplierX,
    offsetY: (width - vortex.minSize) * vortex.offsetMultiplierY
  })

}

function updateVortex(vortex) {
  vortex.deepness = 10 + (sin(frameCount * PI / 360) * 5)
  updateMinSize(vortex)
  //updateDividerOffset(vortex)
  updateLayers(vortex)
}

function updateMinSize(vortex) {
  vortex.sizeNoise += 1.5
  vortex.minSize = vortex.originalMinSize + (sin(frameCount * PI / 360) * (vortex.originalMinSize / 2))
}


function updateDividerOffset(vortex) {
  let x = cos(3 * frameCount * PI / 360)
  let y = sin(1 * frameCount * PI / 360)

  vortex.offsetMultiplierX = map(x, -1, 1, 0.1, 0.9)
  vortex.offsetMultiplierY = map(y, -1, 1, 0.1, 0.9)
}

function updateLayers(vortex) {
  _.forEach(vortex.layers, layer => { 
    layer.size = layer.size >= width ? vortex.minSize : layer.size + 1
    layer.offsetX = (width - layer.size) * vortex.offsetMultiplierX
    layer.offsetY = (width - layer.size) * vortex.offsetMultiplierY
  })
}

function drawGrid(vortex) {
  push()
  translate(width / 2, height / 2)

  let c1 = color(249, 9, 137)
  let c2 = color(29, 9, 242)
  blendMode(ADD)
  strokeWeight(2)

  let gridLines = 10 + (sin(frameCount * PI / 360) * 10 / 2)
  let vertexCount = 4
  let vertexTheta = TWO_PI / vertexCount

  _.times(vertexCount, v => {
    v += 1
    let offset = (HALF_PI) * (v - 1) + (PI / vertexCount)
    let theta = (vertexTheta / gridLines)

    _.times(gridLines + 1, (l) => {
      let x = cos((l * theta) + offset)
      let y = sin((l * theta) + offset)
      let m = max(abs(x), abs(y))
      let xMin = ((vortex.minSize / 2) * x) / m
      let yMin = ((vortex.minSize / 2)* y) / m
      let xMax = ((width / 2) * x) / m
      let yMax = ((height / 2) * y) / m

      stroke(c1)
      line(xMin, yMin, xMax, yMax)
    })

  })

  pop()
}

function drawLayer(layer) {
  push()
  translate(layer.offsetX, layer.offsetY)

  noFill()
  blendMode(ADD)

  strokeWeight(1)
  stroke(0)
  rect(0, 0, layer.size, layer.size)
  stroke(255, 91, 233)

  strokeWeight(2)
  rect(-1, -1, layer.size + 2, layer.size + 2)
  stroke(0, 238, 24)
  rect(1, 1, layer.size - 2, layer.size - 2)

  pop()
}

function calcLayerOffsetWithMouse(layer) {
  let mouseOffsetX = constrain(mouseX, 0, width) - width / 2
  let mouseOffsetY = constrain(mouseY, 0, height) - height / 2

  let offsetX
  let offsetY

  if (mouseOffsetX > 0)
    offsetX = (width - layer.size) / map(abs(mouseOffsetX), 0, width / 2, 2, 1.1)
  else
    offsetX = (width - layer.size) / map(abs(mouseOffsetX), 0, width / 2, 2, 10)

  if (mouseOffsetY > 0)
    offsetY = (height - layer.size) / map(abs(mouseOffsetY), 0, height / 2, 2, 1.1)
  else
    offsetY = (height - layer.size) / map(abs(mouseOffsetY), 0, height / 2, 2, 10)
  
  return {
    offsetX,
    offsetY
  }
}