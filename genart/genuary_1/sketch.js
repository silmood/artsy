// 1. Triple Nested Loop
// Author: Genwaver

let circles
let startNRot
let nRot

function setup() {
  createCanvas(800, 800);
  circles = _.times(3, (i) => {
    let position = createVector(width/2, (i * height / 4) + height / 4)
    //let position = createVector(random(width), random(height))
    return createCircle(position, color(0))
  })
  startNRot = random(10)
  nRot = startNRot
}

function draw() {
  background(0);

  _.forEach(circles, updateCircle)
  _.forEach(circles, c => {
    drawCircle(c)
    nRot += 0.006
  })

}

function updateCircle(circle) {
  circle.nY += 0.0056
}

function drawCircle(circle) {
  push()
  noFill()
  translate(circle.pos.x, circle.pos.y)

  rotate(circle.rot + (frameCount * HALF_PI/360))

  let segments = circle.r / 3.5
  let theta = PI / segments

  let noiseX = circle.nX

  _.times(segments + 1, i => {
    let t1 = (theta * i)
    let t2 = -t1

    stroke(255)

    //let r1 = (circle.r / 2)
    //let r2 = (circle.r / 2)

    t1 = t1 + (noise(noiseX, circle.nY) * PI / 2)
    noiseX += 0.0076
    t2 = t2 + (noise(noiseX, circle.nY) * PI / 2)
    noiseX += 0.0076

    let r = circle.r + (sin(frameCount * HALF_PI/128) * circle.r / 16)
    let r1 = (r / 2) + ((noise(noiseX, circle.nY) * r / 4) - r/24)
    let r2 = (r / 2) + ((noise(noiseX, circle.nY) * r / 4) - r/24)

    let lineInit = createVector(cos(t1) * r1, sin(t1) * r1)
    let lineEnd = createVector(cos(t2) * r2, sin(t2) * r2)

    point(lineInit.x, lineInit.y)
    point(lineEnd.x, lineEnd.y)

    strokeWeight(segments / 100)
    line(lineInit.x, lineInit.y, lineEnd.x, lineEnd.y) 

  })
  pop()
}

function createCircle(position, color) {
  let r = random(width / 4, width / 2)
  let startNX = random(10)
  let startNY = random(10)
  let nX = startNX
  let nY = startNY

  return {
    r,
    rot: random(0, TWO_PI),
    nX,
    nY,
    color,
    pos: position
  }
}
