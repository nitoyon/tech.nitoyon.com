---
layout: post
title: Go 言語で宇宙旅行風のアニメーション GIF を作った
tags: Go
lang: ja
thumbnail: http://tech.nitoyon.com/ja/blog/2016/01/18/space-travel-animated-gif/space-thumb.gif
seealso:
- ja/2016-01-07-go-animated-gif-gen
- ja/2015-12-31-go-image-gen
---
宇宙旅行風のアニメーション GIF を Golang で生成してみた。完成品はこちら。

<img src="http://img.gifmagazine.net/gifmagazine/images/704479/original.gif" width="500" height="250" alt="宇宙旅行風 (463KB)">

ソースコードはこの記事の末尾に掲載しています。以下では使ったライブラリーやテクニックを簡単に説明します。

draw2d を使って描画する
=======================

Golang の標準ライブラリーだけでは複雑な図形を描画するのは難しいので、[draw2d](https://github.com/llgcode/draw2d) を使ってみることにした。こいつを使えば、線とか弧とかベジェ曲線を描けるし、線の色や塗る色も設定できる。

次のコードでは、`draw2dimg` と `draw2dkit` を使って、#808080 の四角を描画する例。

```go
package main

import (
    "github.com/llgcode/draw2d/draw2dimg"
    "github.com/llgcode/draw2d/draw2dkit"
    "image"
    "image/color"
)

func main() {
    img := image.NewRGBA(image.Rect(0, 0, 200, 200))
    gc := draw2dimg.NewGraphicContext(img)

    // Draw rectangle (#808080)
    gc.SetFillColor(color.Gray{0x80})
    draw2dkit.Rectangle(gc, 50, 50, 100, 100)
    gc.Fill()
    gc.Close()
}
```

`draw2dimg.NewGraphicContext` は引数に `image.RGBA` (透明度つきの RGB 画像) を渡す必要があるんだけど、アニメーション GIF を `gif.EncodeAll` で作るときには `image.Palettted` (パレットの色だけを使った画像) を渡さなきゃいけない。

つまり、draw2d でアニメーション GIF を作るには、次のような処理が必要になる。

1. `iamge.RBGA` を作る
2. draw2d を使って描画する
3. `image.RBGA` を `image.Paletted` に変換する
4. `gif.EncodeAll` に `[]*image.Paletted` を渡して、アニメーション GIF を作る


`image.RBGA` を `image.Paletted` に変換する方法
===============================================

1 枚の GIF を生成する `gif.Encode` は自動的に `image.RBGA` を `image.Paletted` に変換するんだけど、アニメーション GIF を生成する `gif.EncodeAll` は変換してくれない。

なので、自分で変換処理を実装する必要がある。といっても、`gif.Encode` と同じように、標準ライブラリで用意された `draw.FloydSteinberg` を使って [フロイド-スタインバーグ・ディザリング](https://ja.wikipedia.org/wiki/%E3%83%95%E3%83%AD%E3%82%A4%E3%83%89-%E3%82%B9%E3%82%BF%E3%82%A4%E3%83%B3%E3%83%90%E3%83%BC%E3%82%B0%E3%83%BB%E3%83%87%E3%82%A3%E3%82%B6%E3%83%AA%E3%83%B3%E3%82%B0) を使うと簡単。こんな風に。

```go
package main

import (
    "image"
    "image/color"
    "image/draw"
)

func main() {
    img := image.NewRGBA(image.Rect(0, 0, 200, 200))

    // パレットを準備 (#ffffff, #000000, #ff0000)
    var palette color.Palette = color.Palette{}
    palette = append(palette, color.White)
    palette = append(palette, color.Black)
    palette = append(palette, color.RGBA{0xff, 0x00, 0x00, 0xff})

    // ディザリングする
    pm := image.NewPaletted(img.Bounds(), palette)
    draw.FloydSteinberg.Draw(pm, img.Bounds(), img, image.ZP)
}
```


ソースコード全体
================

全部で 100 行になってます。

```go
package main

import (
    "github.com/llgcode/draw2d/draw2dimg"
    "github.com/llgcode/draw2d/draw2dkit"
    "image"
    "image/color"
    "image/draw"
    "image/gif"
    "math"
    "math/rand"
    "os"
)

var w, h float64 = 500, 250
var palette color.Palette = color.Palette{}
var zCycle float64 = 8
var zMin, zMax float64 = 1, 15

type Point struct {
    X, Y float64
}

type Circle struct {
    X, Y, Z, R float64
}

// ループするように星を描画する
func (c *Circle) Draw(gc *draw2dimg.GraphicContext, ratio float64) {
    z := c.Z - ratio*zCycle

    for z < zMax {
        if z >= zMin {
            x, y, r := c.X/z, c.Y/z, c.R/z
            gc.SetFillColor(color.White)
            gc.Fill()
            draw2dkit.Circle(gc, w/2+x, h/2+y, r)
            gc.Close()
        }
        z += zCycle
    }
}

func drawFrame(circles []Circle, ratio float64) *image.Paletted {
    img := image.NewRGBA(image.Rect(0, 0, int(w), int(h)))
    gc := draw2dimg.NewGraphicContext(img)

    // 背景を描画
    gc.SetFillColor(color.Gray{0x11})
    draw2dkit.Rectangle(gc, 0, 0, w, h)
    gc.Fill()
    gc.Close()

    // 星を描画
    for _, circle := range circles {
        circle.Draw(gc, ratio)
    }

    // ディザリングする
    pm := image.NewPaletted(img.Bounds(), palette)
    draw.FloydSteinberg.Draw(pm, img.Bounds(), img, image.ZP)
    return pm
}

func main() {
    // 4000 個の星を準備
    circles := []Circle{}
    for len(circles) < 4000 {
        x, y := rand.Float64()*8-4, rand.Float64()*8-4
        if math.Abs(x) < 0.5 && math.Abs(y) < 0.5 {
            continue
        }
        z := rand.Float64() * zCycle
        circles = append(circles, Circle{x * w, y * h, z, 5})
    }

    // パレットを準備 (#000000, #111111, ..., #ffffff)
    palette = color.Palette{}
    for i := 0; i < 16; i++ {
        palette = append(palette, color.Gray{uint8(i) * 0x11})
    }

    // 30 個の画像を作成
    var images []*image.Paletted
    var delays []int
    count := 30
    for i := 0; i < count; i++ {
        pm := drawFrame(circles, float64(i)/float64(count))
        images = append(images, pm)
        delays = append(delays, 4)
    }

    // gif を出力
    f, _ := os.OpenFile("space.gif", os.O_WRONLY|os.O_CREATE, 0600)
    defer f.Close()
    gif.EncodeAll(f, &gif.GIF{
        Image: images,
        Delay: delays,
    })
}
```
