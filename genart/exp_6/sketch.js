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
  updateDividerOffset(vortex)
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
  strokeWeight(0.75)

  push()
  let c1 = color(249, 9, 137)
  let c2 = color(29, 9, 242)
  blendMode(ADD)
  strokeWeight(2)

  let gridLines = 10 + (sin(frameCount * PI / 360) * 10 / 2)
  let maxSpacing = width / gridLines
  let minSpacing = vortex.minSize / gridLines
  let offsetX = (width - vortex.minSize) * vortex.offsetMultiplierX
  let offsetY = (width - vortex.minSize) * vortex.offsetMultiplierY
  let vortexMinRect = {
    leftTop: createVector(offsetX, offsetY),
    rightTop: createVector(offsetX + vortex.minSize, offsetY),
    leftBottom: createVector(offsetX, offsetY + vortex.minSize),
    rightBottom: createVector(offsetX + vortex.minSize, offsetY + vortex.minSize),
  }

  _.times(gridLines + 1, i => {
    stroke(c1)
    line(i * maxSpacing -1, 0, (vortexMinRect.leftTop.x + i * minSpacing) - 1, (vortexMinRect.leftTop.y))
    stroke(c2)
    line(i * maxSpacing + 1 , 0, (vortexMinRect.leftTop.x + i * minSpacing) + 1, (vortexMinRect.leftTop.y))
  })

  _.times(gridLines + 1, i => {
    stroke(c1)
    line(0, i * maxSpacing - 1, vortexMinRect.leftTop.x , (vortexMinRect.leftTop.y + i * minSpacing) - 1)
    stroke(c2)
    line(0, i * maxSpacing + 1, vortexMinRect.leftTop.x , (vortexMinRect.leftTop.y + i * minSpacing) + 1)
  })

  _.times(gridLines + 1, i => {
    stroke(c1)
    line(i * maxSpacing - 1, height, (vortexMinRect.leftBottom.x + i * minSpacing) - 1, vortexMinRect.rightBottom.y)
    stroke(c2)
    line(i * maxSpacing + 1, height, (vortexMinRect.leftBottom.x + i * minSpacing) + 1, vortexMinRect.rightBottom.y)
  })

  _.times(gridLines + 1, i => {
    stroke(c1)
    line(width, i * maxSpacing - 1, vortexMinRect.rightBottom.x, (vortexMinRect.rightTop.y + i * minSpacing) - 1)
    stroke(c2)
    line(width, i * maxSpacing + 1, vortexMinRect.rightBottom.x, (vortexMinRect.rightTop.y + i * minSpacing) + 1)
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