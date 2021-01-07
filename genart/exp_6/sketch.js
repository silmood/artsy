let vortexA

function setup() {
  createCanvas(512, 512)
  vortexA = createVortex()
}

function draw() {
  background(0)
  drawVortex(vortexA)
}

function createVortex(offset = createVector(0, 0)) {
  let deepness = 10
  let minSize = 100
  let vortexSize = width
  let sizeNoise = random(10)
  let offsetMultiplierX = 0.5
  let offsetMultiplierY = 0.5
  let c1 = color(255, 0, 19)
  let c2 = color(0, 242, 255)
  let speed = 1

  let layers = _.times(deepness, layer => {
    return {
      size: map(layer, 0, deepness, minSize, vortexSize),
      offsetX: (width - layer.size) * offsetMultiplierX,
      offsetY: (height - layer.size) * offsetMultiplierY,
      cR: color(241, 56, 244),
      cB: color(0, 242, 255),
    }
  })

  let starsTheta = TWO_PI / 360

  let stars = _.times(1024, star => {
    let t = random(360) * starsTheta
    let r = random(minSize, vortexSize)
    return {
      lightR: random(10),
      lightB: random(10),
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
    minSize,
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
  drawLayer(vortex, { 
    size: vortex.minSize, 
    offsetX: (width - vortex.minSize) * vortex.offsetMultiplierX + vortex.minSize / 2 + vortex.offset.x,
    offsetY: (width - vortex.minSize) * vortex.offsetMultiplierY + vortex.minSize / 2 + vortex.offset.y,
    cR: color(255, 0, 19),
    cB: color(0, 242, 255),
  })

}

function updateVortex(vortex) {
  updateMinSize(vortex)
  updateSpeed(vortex)
  updateDividerOffset(vortex)
  updateLayers(vortex)
  updateStars(vortex)
}

function updateMinSize(vortex) {
  vortex.minSize = vortex.originalMinSize + (sin(frameCount * PI / 360) * (vortex.minSize / 2))
}

function updateSpeed(vortex) {
  vortex.speed = map(vortex.minSize, vortex.originalMinSize - (vortex.originalMinSize / 2), vortex.originalMinSize + (vortex.originalMinSize / 2), 1, 3)
}


function updateDividerOffset(vortex) {
  let x = cos(3 * frameCount * PI / 720)
  let y = sin(2 * frameCount * PI / 360)

  vortex.offsetMultiplierX = map(x, -1, 1, 0.1, 0.9)
  vortex.offsetMultiplierY = map(y, -1, 1, 0.3, 0.7)
}

function updateLayers(vortex) {
  let maxSize = 0
  _.forEach(vortex.layers, layer => { 
    layer.size = layer.size >= vortex.size ? vortex.minSize : layer.size + vortex.speed
    maxSize = layer.size > maxSize ? layer.size : maxSize
    layer.offsetX = ((width - layer.size) * vortex.offsetMultiplierX + layer.size / 2) + vortex.offset.x
    layer.offsetY = ((width - layer.size) * vortex.offsetMultiplierY + layer.size / 2) + vortex.offset.y
  })

  vortex.maxSize = maxSize
}

function updateStars(vortex) {
  _.forEach(vortex.stars, star => {
    if (star.radius >= vortex.size) {
      star.radius = random(vortex.minSize - (vortex.minSize * 0.6), vortex.minSize + (vortex.minSize / 2))
    } else {
      star.radius += (vortex.speed * 1)
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

  let gridLines = 10 + (sin(frameCount * PI / 360) * 15 / 2)
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


      strokeWeight(0.75)
      stroke(255)
      line(xMin, yMin, xMax, yMax)
      stroke(vortex.c1)
      line(xMin - 0.75, yMin - 0.75, xMax - 0.75, yMax - 0.75)
      stroke(vortex.c2)
      line(xMin + 0.75, yMin + 0.75, xMax + 0.75, yMax + 0.75)

    })

  })

  pop()
}

function drawLayer(vortex, layer, rot = false) {
  push()
  translate(layer.offsetX, layer.offsetY)
  if(rot)
    rotate(frameCount * (PI / 360))
  rectMode(CENTER)

  noFill()
  blendMode(ADD)

  strokeWeight(1)

  layer.cR.setAlpha(map(layer.size, vortex.minSize, vortex.size, 100, 255))
  layer.cB.setAlpha(map(layer.size, vortex.minSize, vortex.size, 255, 100))

  stroke(255, map(layer.size, vortex.minSize, vortex.size, 255, 0))
  rect(0, 0, layer.size, layer.size)

  stroke(layer.cR)
  rect(0, 0, layer.size + 2, layer.size + 2)

  stroke(layer.cB)
  rect(0, 0, layer.size - 2, layer.size - 2)

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
    let st1 = 255 * abs(sin(frameCount * star.lightR * (PI / 360)))
    let st2 = 255 * abs(sin(frameCount * star.lightB * (PI / 360)))

    strokeWeight(2)
    star.cR.setAlpha(st1)
    star.cB.setAlpha(st2)

    stroke(star.cR)
    point(star.position.x, star.position.y)

    stroke(star.cB)
    point(star.position.x, star.position.y)
  })

  pop()
}
