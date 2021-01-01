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
  let offsetDividerX = 2
  let offsetDividerY = 2

  let layers = _.times(deepness, layer => {
    return {
      size: map(layer, 0, deepness, minSize, width),
      offsetX: (width - layer.size) / offsetDividerX,
      offsetY: (height - layer.size) / offsetDividerY
    }
  })

  return {
    minSize,
    deepness,
    layers,
    offsetDividerX,
    offsetDividerY
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
  updateDividerOffset(vortex)
  updateLayers(vortex)
}

function updateDividerOffset(vortex) {
  let x = cos(2 * frameCount * PI / 320)
  let y = sin(3 * frameCount * PI / 320)

  vortex.offsetMultiplierX = map(x, -1, 1, 0.1, 0.9)
  vortex.offsetMultiplierY = map(y, -1, 1, 0.1, 0.9)
}

function updateLayers(vortex) {
  _.forEach(vortex.layers, layer => { 
    layer.size = layer.size >= width ? vortex.minSize : layer.size + 5
    layer.offsetX = (width - layer.size) * vortex.offsetMultiplierX
    layer.offsetY = (width - layer.size) * vortex.offsetMultiplierY
  })
}

function drawGrid(vortex) {
  strokeWeight(0.75)
  stroke(255)
  let gridLines = 5
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
    line(i * maxSpacing, 0, vortexMinRect.leftTop.x + i * minSpacing, vortexMinRect.leftTop.y)
  })

  _.times(gridLines + 1, i => {
    line(0, i * maxSpacing, vortexMinRect.leftTop.x , vortexMinRect.leftTop.y + i * minSpacing)
  })

  _.times(gridLines + 1, i => {
    line(i * maxSpacing, height, vortexMinRect.leftBottom.x + i * minSpacing, vortexMinRect.leftBottom.y)
  })

  _.times(gridLines + 1, i => {
    line(width, i * maxSpacing, vortexMinRect.rightTop.x, vortexMinRect.rightTop.y + i * minSpacing)
  })


}

function drawLayer(layer) {
  push()
  translate(layer.offsetX, layer.offsetY)

  noFill()
  strokeWeight(0.75)
  stroke(255)
  rect(0, 0, layer.size, layer.size)

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