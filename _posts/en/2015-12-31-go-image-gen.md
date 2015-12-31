---
layout: post
title: Generate an image programmatically with Golang
tags: Go
lang: en
thumbnail: http://tech.nitoyon.com/ja/blog/2015/12/31/go-image-gen/rgb2.png
alternate:
  lang: ja_JP
  url: /ja/blog/2015/12/31/go-image-gen/
---
Golang makes it easy to generate an image using image package. We don't have to build imagemagick nor GD. Just use golang.

But, image package offers us a method for changing color of a pixel. If we want to draw lines or paint colors, we have to use other libraries such as [draw2d](https://github.com/llgcode/draw2d).

This article shows how to generate an image only using standard library.


Simplest Example
================

First, let's make a simple image.

```go
package main

import "image"
import "image/color"
import "image/png"
import "os"

func main() {
    // Create an 100 x 50 image
    img := image.NewRGBA(image.Rect(0, 0, 100, 50))

    // Draw a red dot at (2, 3)
    img.Set(2, 3, color.RGBA{255, 0, 0, 255})

    // Save to out.png
    f, _ := os.OpenFile("out.png", os.O_WRONLY|os.O_CREATE, 0600)
    defer f.Close()
    png.Encode(f, img)
}
```


More Complecated Example
========================

Then, let's make more complected image!

<center><img src="/ja/blog/2015/12/31/go-image-gen/rgb1.png" width="280" height="240"></center>

The code is as follows:

```go
package main

import (
    "fmt"
    "image"
    "image/color"
    "image/png"
    "math"
    "os"
)

type Circle struct {
    X, Y, R float64
}

func (c *Circle) Brightness(x, y float64) uint8 {
    var dx, dy float64 = c.X - x, c.Y - y
    d := math.Sqrt(dx*dx+dy*dy) / c.R
    if d > 1 {
        return 0
    } else {
        return 255
    }
}

func main() {
    var w, h int = 280, 240
    var hw, hh float64 = float64(w / 2), float64(h / 2)
    r := 40.0
    θ := 2 * math.Pi / 3
    cr := &Circle{hw - r*math.Sin(0), hh - r*math.Cos(0), 60}
    cg := &Circle{hw - r*math.Sin(θ), hh - r*math.Cos(θ), 60}
    cb := &Circle{hw - r*math.Sin(-θ), hh - r*math.Cos(-θ), 60}

    m := image.NewRGBA(image.Rect(0, 0, w, h))
    for x := 0; x < w; x++ {
        for y := 0; y < h; y++ {
            c := color.RGBA{
                cr.Brightness(float64(x), float64(y)),
                cg.Brightness(float64(x), float64(y)),
                cb.Brightness(float64(x), float64(y)),
                255,
            }
            m.Set(x, y, c)
        }
    }

    f, err := os.OpenFile("rgb.png", os.O_WRONLY|os.O_CREATE, 0600)
    if err != nil {
        fmt.Println(err)
        return
    }
    defer f.Close()
    png.Encode(f, m)
}
```

We define `Circle` struct, and determine color by calling its `Brightness` method.

```go
c := color.RGBA{
    cr.Brightness(float64(x), float64(y)),
    cg.Brightness(float64(x), float64(y)),
    cb.Brightness(float64(x), float64(y)),
    255,
}
```

`Brightness` returns `255` when (x, y) is in red circle and returns `0` when not.


Blur Circles
============

Finally, let's blur circles.

<center><img src="/ja/blog/2015/12/31/go-image-gen/rgb2.png" width="280" height="240"></center>

We only modified `return 255` to `uint8((1 - math.Pow(d, 5)) * 255)`.

```go
func (c *Circle) Brightness(x, y float64) uint8 {
    var dx, dy float64 = c.X - x, c.Y - y
    d := math.Sqrt(dx*dx+dy*dy) / c.R
    if d > 1 {
        // outside
        return 0
    } else {
        // inside
        return uint8((1 - math.Pow(d, 5)) * 255)
    }
}
```
