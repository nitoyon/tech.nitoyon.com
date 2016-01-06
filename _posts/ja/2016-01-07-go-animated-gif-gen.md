---
layout: post
title: Go 言語でアニメーション GIF を作成する
tags: Go
lang: ja
thumbnail: http://tech.nitoyon.com/ja/blog/2016/01/07/go-animated-gif-gen/rgb.gif
alternate:
  lang: en_US
  url: /en/blog/2016/01/07/go-animated-gif-gen/
---
Golang でアニメーション GIF を作る手順を 3 通り紹介します。

* フレームごとの画像から生成
* ビデオから生成
* Go 言語で最初から生成


フレームごとの画像から生成
==========================

こんな GIF 画像があったとします ([ここ](http://qiita.com/mattn/items/b7889e3c036b408ae8bd) より拝借)。

<img src="/ja/blog/2016/01/07/go-animated-gif-gen/g1.gif" width="200" height="200">
<img src="/ja/blog/2016/01/07/go-animated-gif-gen/g2.gif" width="200" height="200">
<img src="/ja/blog/2016/01/07/go-animated-gif-gen/g3.gif" width="200" height="200">

変換結果はこんな感じ。

<center><img src="/ja/blog/2016/01/07/go-animated-gif-gen/gopher.gif" width="200" height="200"></center>

生成するためのコードはこんな感じ。

```go
package main

import "image"
import "image/gif"
import "os"

func main() {
    files := []string{"g1.gif", "g2.gif","g3.gif", "g2.gif"}

    // 各フレームの画像を GIF で読み込んで outGif を構築する
    outGif := &gif.GIF{}
    for _, name := range files {
        f, _ := os.Open(name)
        inGif, _ := gif.Decode(f)
        f.Close()

        outGif.Image = append(outGif.Image, inGif.(*image.Paletted))
        outGif.Delay = append(outGif.Delay, 0)
    }

    // out.gif に保存する
    f, _ := os.OpenFile("out.gif", os.O_WRONLY|os.O_CREATE, 0600)
    defer f.Close()
    gif.EncodeAll(f, outGif)
}
```

注意したいポイントは次の通り。

* フレームの GIF を順番に `gif.Decode` で読み込んでいる。JPEG から生成するには、GIF への変換処理を実装する必要がある ([goanigiffy](https://github.com/srinathh/goanigiffy) では `gif.Encode` と `gif.Decode` を呼んで変換している)。
* GIF アニメーションを生成するには `gif.EncodeAll` を呼ぶ。


ビデオから生成
==============

[MPlayer](http://www.mplayerhq.hu/) を使って各フレームの画像を抽出してから、[goanigiffy](https://github.com/srinathh/goanigiffy) で GIF アニメーションを生成する (詳しくは [GoAniGiffy](http://srinathh.github.io/opensource/goanigiffy/)  を参照)。


Go 言語で最初から生成
=====================

こんな感じのものを作ってみた。

<center><img src="/ja/blog/2016/01/07/go-animated-gif-gen/rgb.gif" width="240" height="240"></center>

各フレームの画像を Go 言語で描画して `[]*image.Paletted` を作って、`gif.EncodeAll` に渡している。

```go
    var images []*image.Paletted
    var delays []int

    // 20 個の画像を生成して円を描く
    for step := 0; step < 20; step++ {
        img := image.NewPaletted(image.Rect(0, 0, w, h), palette)
        images = append(images, img)
        delays = append(delays, 0)

        // 描画処理 (長いので省略)
    }

    // rgb.gif に保存する
    f, _ := os.OpenFile("rgb.gif", os.O_WRONLY|os.O_CREATE, 0600)
    defer f.Close()
    gif.EncodeAll(f, &gif.GIF{
        Image: images,
        Delay: delays,
    })

```

全体のコードはこんな感じ。

```go
package main

import (
    "image"
    "image/color"
    "image/gif"
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
    var w, h int = 240, 240
    var hw, hh float64 = float64(w / 2), float64(h / 2)
    circles := []*Circle{&Circle{}, &Circle{}, &Circle{}}

    var palette = []color.Color{
        color.RGBA{0x00, 0x00, 0x00, 0xff},
        color.RGBA{0x00, 0x00, 0xff, 0xff},
        color.RGBA{0x00, 0xff, 0x00, 0xff},
        color.RGBA{0x00, 0xff, 0xff, 0xff},
        color.RGBA{0xff, 0x00, 0x00, 0xff},
        color.RGBA{0xff, 0x00, 0xff, 0xff},
        color.RGBA{0xff, 0xff, 0x00, 0xff},
        color.RGBA{0xff, 0xff, 0xff, 0xff},
    }

    var images []*image.Paletted
    var delays []int
    steps := 20
    for step := 0; step < steps; step++ {
        img := image.NewPaletted(image.Rect(0, 0, w, h), palette)
        images = append(images, img)
        delays = append(delays, 0)

        θ := 2.0 * math.Pi / float64(steps) * float64(step)
        for i, circle := range circles {
            θ0 := 2 * math.Pi / 3 * float64(i)
            circle.X = hw - 40*math.Sin(θ0) - 20*math.Sin(θ0+θ)
            circle.Y = hh - 40*math.Cos(θ0) - 20*math.Cos(θ0+θ)
            circle.R = 50
        }

        for x := 0; x < w; x++ {
            for y := 0; y < h; y++ {
                img.Set(x, y, color.RGBA{
                    circles[0].Brightness(float64(x), float64(y)),
                    circles[1].Brightness(float64(x), float64(y)),
                    circles[2].Brightness(float64(x), float64(y)),
                    255,
                })
            }
        }
    }

    f, _ := os.OpenFile("rgb.gif", os.O_WRONLY|os.O_CREATE, 0600)
    defer f.Close()
    gif.EncodeAll(f, &gif.GIF{
        Image: images,
        Delay: delays,
    })
}
```

以上です。
