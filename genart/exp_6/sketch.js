let vortexA
let theta = 0
let capturing = false
let renderer
let animationSpeed = 180
let minLayer, maxLayer


function setup() {
  renderer = createCanvas(512, 512)
  capturer = new CCapture( { format: 'webm', framerate: 30, verbose: true, display: false, quality: 30 } )
  frameRate(30)

  vortexA = createVortex()

  minLayer = {
    size: vortexA.minSize, 
    offsetX: (width - vortexA.minSize) * vortexA.offsetMultiplierX + vortexA.minSize / 2 + vortexA.offset.x,
    offsetY: (width - vortexA.minSize) * vortexA.offsetMultiplierY + vortexA.minSize / 2 + vortexA.offset.y,
    cR: color(241, 56, 244),
    cB: color(0, 242, 255)
  }

  maxLayer = {
    size: vortexA.size, 
    offsetX: (width - vortexA.minSize) * vortexA.offsetMultiplierX + vortexA.minSize / 2 + vortexA.offset.x,
    offsetY: (width - vortexA.minSize) * vortexA.offsetMultiplierY + vortexA.minSize / 2 + vortexA.offset.y,
    cR: color(241, 56, 244),
    cB: color(0, 242, 255)
  }

}

function draw() {
  background(0)
  drawVortex(vortexA)

  if (theta >= (PI) && !capturing) {
    capturer.start()
    capturer.capture(renderer.canvas)
    capturing = true
  } else if (theta >= (PI * 3) && capturing) {
    noLoop()
    capturer.stop()
    capturer.save()
    capturing = false
  }

  capturer.capture(renderer.canvas)
  theta = frameCount * (PI / (animationSpeed * 2))
}

function createVortex(offset = createVector(0, 0)) {
  let deepness = 10
  let vortexSize = 6 * (width / 8)
  let minSize = vortexSize / 2
  let offsetMinSize = 3 * minSize / 7
  let sizeNoise = random(10)
  let offsetMultiplierX = 0.5
  let offsetMultiplierY = 0.5
  let c1 = color(255, 0, 19)
  let c2 = color(0, 242, 255)
  let speed = 1

  let layers = _.times(deepness, layer => {
    return {
      size: map(layer, 0, deepness, minSize - offsetMinSize, vortexSize),
      offsetX: (width - layer.size) * offsetMultiplierX,
      offsetY: (height - layer.size) * offsetMultiplierY,
      cR: color(241, 56, 244),
      cB: color(0, 242, 255),
    }
  })

  let starsTheta = TWO_PI / 360

  let stars = _.times(2048, star => {
    let t = random(360) * starsTheta
    let r = random(minSize, vortexSize)
    return {
      lightR: random(100),
      lightB: random(100),
      cR: color(241, 56, 244),
      cB: color(0, 242, 255),
      theta: t,
      radius: r,
      position: createVector(r * cos(t), r * sin(t))
    }
  })

  return {
    originalMinSize: minSize,
    size: vortexSize,
    minSize: minSize - offsetMinSize,
    offsetMinSize,
    deepness,
    layers,
    stars,
    sizeNoise,
    offsetMultiplierX,
    offsetMultiplierY,
    speed,
    offset,
    c1,
    c2,
  }
}


function drawVortex(vortex) {
  updateVortex(vortex)

  _.forEach(vortex.layers, (l) => drawLayer(vortex, l))

  drawGrid(vortex)
  drawStars(vortex)

  drawLayer(vortex, minLayer)
  drawLayer(vortex, maxLayer)

}

function updateVortex(vortex) {
  updateMinSize(vortex)
  updateSpeed(vortex)
  //updateDividerOffset(vortex)
  updateLayers(vortex)
  updateStars(vortex)
}

function updateMinSize(vortex) {
  vortex.minSize = vortex.originalMinSize + (sin(frameCount * PI / animationSpeed) * vortex.offsetMinSize)
  minLayer.size = vortex.minSize
}

function updateSpeed(vortex) {
  vortex.speed = map(vortex.minSize,
    vortex.originalMinSize - vortex.offsetMinSize,
    vortex.originalMinSize + vortex.offsetMinSize,
      1,
      2
    ) 
}


function updateDividerOffset(vortex) {
  let x = cos(2 * frameCount * PI / animationSpeed)
  let y = sin(0 * frameCount * PI / (animationSpeed / 2))

  vortex.offsetMultiplierX = map(x, -1, 1, 0.3, 0.7)
  vortex.offsetMultiplierY = map(y, -1, 1, 0.3, 0.7)
}

function updateLayers(vortex) {
  _.forEach(vortex.layers, layer => { 
    layer.size = layer.size >= vortex.size  ? (vortex.originalMinSize - vortex.offsetMinSize)  : layer.size + vortex.speed

    layer.offsetX = ((width - layer.size) * vortex.offsetMultiplierX + layer.size / 2) + vortex.offset.x
    layer.offsetY = ((height - layer.size) * vortex.offsetMultiplierY + layer.size / 2) + vortex.offset.y
  })

}

function updateStars(vortex) {
  _.forEach(vortex.stars, star => {
    if (star.radius >= (vortex.size + 70)) {
      star.radius = random(vortex.minSize - (vortex.minSize * 0.6), vortex.minSize + (vortex.minSize / 2))
    } else {
      star.radius += (vortex.speed * 2.5)
    }
    star.position = createVector(star.radius * cos(star.theta), star.radius * sin(star.theta))
  })
}


function drawGrid(vortex) {
  push()
  let gridOriginX = (((width - vortex.minSize) * vortex.offsetMultiplierX) + vortex.minSize / 2) + vortex.offset.x
  let gridOriginY = (((height - vortex.minSize) * vortex.offsetMultiplierY) + vortex.minSize / 2) + vortex.offset.y

  translate(
    gridOriginX,
    gridOriginY
  )

  blendMode(ADD)

  let gridLines = 12 + (sin(frameCount * PI / animationSpeed) * 12 / 2)
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
      let xMin = ((vortex.minSize / 2) * x) / m
      let yMin = ((vortex.minSize / 2) * y) / m
      let xMax = (((vortex.size / 2) * x) / m) + (width / 2 - gridOriginX)
      let yMax = (((vortex.size / 2) * y) / m) + (height / 2 - gridOriginY)


      strokeWeight(0.5)
      stroke(255)
      line(xMin, yMin, xMax, yMax)
      stroke(vortex.c1)
      line(xMin - 0.5, yMin - 0.5, xMax - 0.5, yMax - 0.5)
      stroke(vortex.c2)
      line(xMin + 0.5, yMin + 0.5, xMax + 0.5, yMax + 0.5)

    })

  })

  pop()
}

function drawLayer(vortex, layer, rot = false) {
  if (layer.size < vortex.minSize) return

  push()
  translate(layer.offsetX, layer.offsetY)
  if(rot)
    rotate(frameCount * (PI / 360))
  rectMode(CENTER)

  noFill()
  blendMode(ADD)

  strokeWeight(0.5)

  layer.cR.setAlpha(map(layer.size, vortex.minSize, vortex.size, 100, 255))
  layer.cB.setAlpha(map(layer.size, vortex.minSize, vortex.size, 255, 100))

  stroke(255, map(layer.size, vortex.minSize, vortex.size, 255, 0))
  rect(0, 0, layer.size, layer.size)

  stroke(layer.cR)
  rect(0, 0, layer.size + 1, layer.size + 1)

  stroke(layer.cB)
  rect(0, 0, layer.size - 1, layer.size - 1)

  pop()
}

function drawStars(vortex) {
  push()
  let gridOriginX = (((width - vortex.minSize) * vortex.offsetMultiplierX) + vortex.minSize / 2) + vortex.offset.x
  let gridOriginY = (((height - vortex.minSize) * vortex.offsetMultiplierY) + vortex.minSize / 2) + vortex.offset.y
  blendMode(ADD)

  translate(
   gridOriginX,
   gridOriginY
  )

  _.forEach(vortex.stars, star => {
    let st1 = 255 * abs(sin(star.lightR * (PI / animationSpeed)))
    let st2 = 255 * abs(sin(star.lightB * (PI / animationSpeed)))

    strokeWeight(1)
    star.cR.setAlpha(st1)
    star.cB.setAlpha(st2)
    star.lightR += 1
    star.lightB += 1

    stroke(star.cR)
    point(star.position.x, star.position.y)

    stroke(star.cB)
    point(star.position.x, star.position.y)
  })

  pop()
}
