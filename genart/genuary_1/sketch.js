// 1. Triple Nested Loop
// Author: Genwaver

let circles
let speed
let capturer
let capture = true
let capturing = false
let renderer

function setup() {
  renderer = createCanvas(540, 540)
  capturer = new CCapture( { format: 'png', framerate: 60, verbose: true, quality: 30 } )
  frameRate(60)

  speed = TWO_PI / 512
  circles = _.times(3, (i) => {
    let rot = random(0, TWO_PI)
    let rotDir = floor(cos(PI * i))
    let moveOffset = 50 * floor(cos(HALF_PI * i))
    let position = createVector(width / 2, height /2)

    return createCircle(position, rot, rotDir, moveOffset, (TWO_PI / 12) * i)
  })
}

function draw() {
  background(0);

  _.forEach(circles, updateCircle)
  _.forEach(circles, drawCircle)

  if(capture && !capturing && (frameCount * speed) % TWO_PI == 0) {
    capturer.start()
    capturer.capture(renderer.canvas)
    capturing = true
  } else if((frameCount * speed) % (TWO_PI) == 0 && capturing){
    capturer.stop()
    capturer.save()
    capturing = false
  }

  capturer.capture(renderer.canvas)
}

function mousePressed(fxn) {
  capture = true
  console.log(capture)
}

function updateCircle(circle) {
  if ((frameCount *  speed) % PI === 0 )
    circle.noiseNudge = -circle.noiseNudge

  circle.nY += circle.noiseNudge
  circle.fr += speed
}

function drawCircle(circle) {
  push()
  noFill()

  let tO = sin(circle.fr) < 0 ? 0 : sin(circle.fr)
  let offset = circle.moveOffset * tO
  translate(circle.pos.x, circle.pos.y + offset)

  rotate(circle.rot + (frameCount * speed * circle.rotDir))

  let segments = circle.r / 2.5
  let theta = PI / segments

  let noiseX = circle.nX

  _.times(segments + 1, i => {
    let t1 = (theta * i)
    let t2 = -t1
    let rOffset = circle.r / 5
    let r = circle.r + (sin(circle.fr) * rOffset)

    t1 = t1 + (noise(noiseX, circle.nY) * PI / 2)
    noiseX += (map(r, circle.r - rOffset, circle.r + rOffset, 0, 0.0098))

    t2 = t2 + (noise(noiseX, circle.nY) * PI / 2)
    noiseX += map(r, circle.r - rOffset, circle.r + rOffset, 0, 0.0098)

    let r1 = (r / 2) + ((noise(noiseX, circle.nY) * r / 4) - r / 6)
    let r2 = (r / 2) + ((noise(noiseX, circle.nY) * r / 4) - r / 6)

    let lineInit = createVector(cos(t1) * r1, sin(t1) * r1)
    let lineEnd = createVector(cos(t2) * r2, sin(t2) * r2)

    blendMode(ADD)
    let sw = segments / 90
    let offset = sw * 2

    strokeWeight(sw)

    let t = PI / (segments / 3)
    let lx = (i * t) + (frameCount * speed * 4)

    let limit1 = 255 * pow(sin(lx), 2) * noise(circle.nC[0], circle.nY)

    let lx2 = (i * t) + (frameCount * speed) + HALF_PI / 4
    let limit2 = 255 * pow(sin(lx2), 2) * noise(circle.nC[1], circle.nY)

    let lx3 = (i * t) + (frameCount * speed) +  3 * HALF_PI / 4
    let limit3 = 255 * pow(sin(lx3), 2) * noise(circle.nC[2], circle.nY)

    stroke(255, limit1)
    line(lineInit.x, lineInit.y, lineEnd.x, lineEnd.y) 

    stroke(252, 40, 213, limit2)
    line(lineInit.x - offset, lineInit.y, lineEnd.x - offset, lineEnd.y) 
    stroke(40, 210, 252, limit3)
    line(lineInit.x + offset, lineInit.y, lineEnd.x + offset, lineEnd.y) 

  })
  pop()
}

function createCircle(position, rot, rotDir, moveOffset, fr) {
  let r = 3 * width / 5
  let startNX = 0 
  let startNY = 0
  let nC = _.times(3, i => random(10))
  let nX = startNX
  let nY = startNY
  let noiseNudge = 0.0056

  return {
    r,
    rot: rot,
    rotDir,
    moveOffset,
    startNX,
    startNY,
    nX,
    nY,
    nC,
    fr,
    pos: position,
    noiseNudge
  }
}
