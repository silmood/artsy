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
  let vortexSize = width + 200
  let sizeNoise = random(10)
  let offsetMultiplierX = 0.5
  let offsetMultiplierY = 0.5

  let layers = _.times(deepness, layer => {
    return {
      size: map(layer, 0, deepness, minSize, vortexSize),
      offsetX: (width - layer.size) * offsetMultiplierX,
      offsetY: (height - layer.size) * offsetMultiplierY
    }
  })

  return {
    originalMinSize: minSize,
    size: vortexSize,
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
  //drawLayer({ 
  //  size: vortex.minSize, 
  //  offsetX: (width - vortex.minSize) * vortex.offsetMultiplierX + vortex.minSize / 2,
  //  offsetY: (width - vortex.minSize) * vortex.offsetMultiplierY + vortex.minSize / 2
  //})

}

function updateVortex(vortex) {
  updateMinSize(vortex)
  updateDividerOffset(vortex)
  updateLayers(vortex)
}

function updateMinSize(vortex) {
  vortex.minSize = vortex.originalMinSize + (sin(frameCount * PI / 360) * (vortex.originalMinSize / 2))
}


function updateDividerOffset(vortex) {
  let x = cos(1 * frameCount * PI / 360)
  let y = sin(4 * frameCount * PI / 720)

  vortex.offsetMultiplierX = 0.5 //map(x, -1, 1, 0.3, 0.6)
  vortex.offsetMultiplierY = map(y, -1, 1, 0.4, 0.6)
}

function updateLayers(vortex) {
  let maxSize = 0
  _.forEach(vortex.layers, layer => { 
    layer.size = layer.size >= vortex.size ? vortex.minSize : layer.size + 1
    maxSize = layer.size > maxSize ? layer.size : maxSize
    layer.offsetX = (width - layer.size) * vortex.offsetMultiplierX + layer.size / 2
    layer.offsetY = (width - layer.size) * vortex.offsetMultiplierY + layer.size / 2
  })

  vortex.maxSize = maxSize
}

function drawGrid(vortex) {
  push()
  let gridOriginX = ((width - vortex.minSize) * vortex.offsetMultiplierX) + vortex.minSize / 2
  let gridOriginY = ((height - vortex.minSize) * vortex.offsetMultiplierY) + vortex.minSize / 2

  translate(
    gridOriginX,
    gridOriginY
  )

  let c1 = color(249, 9, 137)
  let c2 = color(29, 9, 242)
  blendMode(ADD)
  strokeWeight(0.15)

  let gridLines = 10 + (sin(frameCount * PI / 720) * 10 / 2)
  let vertexCount = 4
  let vertexTheta = TWO_PI / vertexCount

  _.times(vertexCount, v => {
    v += 1
    let offset = (TWO_PI / vertexCount) * (v - 1) + (PI / vertexCount) 

    let theta = (vertexTheta / gridLines)

    _.times(gridLines + 1, (l) => {

      let x = cos((l * theta) + offset)
      let y = sin((l * theta) + offset)

      let xM = cos((l * theta) + (offset + (frameCount * (PI / 360) )))
      let yM = sin((l * theta) + (offset + (frameCount * (PI / 360) )))

      let m = max(abs(x), abs(y))
      let xMin = ((vortex.minSize / 2) * xM) / m
      let yMin = ((vortex.minSize / 2) * yM) / m
      let xMax = (((vortex.size / 2) * x) / m) + (width / 2 - gridOriginX)
      let yMax = (((vortex.size / 2) * y) / m) + (height / 2 - gridOriginY)

      strokeWeight(0.5)
      stroke(c1)
      line(xMin, yMin, xMax, yMax)
      stroke(c2)
      line(xMin - 2, yMin - 2, xMax - 2, yMax - 2)

      stroke(255)
      strokeWeight(1)
      point(xMin, yMin)
    })

  })

  pop()
}

function drawLayer(layer) {
  push()
  translate(layer.offsetX, layer.offsetY)
  rotate(frameCount * (PI / 360))
  rectMode(CENTER)
  ellipseMode(CENTER)

  noFill()
  blendMode(ADD)

  strokeWeight(0.5)
  stroke(255)
  rect(0, 0, layer.size, layer.size)
  stroke(255, 91, 233)

  strokeWeight(0.5)
  rect(0, 0, layer.size + 2, layer.size + 2)
  stroke(0, 238, 24)
  rect(0, 0, layer.size - 2, layer.size - 2)

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