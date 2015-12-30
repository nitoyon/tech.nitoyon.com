---
layout: post
title: Go 言語でソースコードから画像生成する
tags: Go
lang: ja
thumbnail: http://tech.nitoyon.com/ja/blog/2015/12/31/go-image-gen/rgb2.png
---
Go 言語には画像生成する image パッケージが標準で入っている。imagemagick や GD を導入する必要がないので、気軽に画像を生成できて便利そうだったので試してみた。

ただ、標準ではピクセル単位で色を設定することしかできないので、線を引いたり色を塗ったりするには、何らかのライブラリーに頼る必要がある。

今回は、ライブラリーには頼らず、標準で提供されている機能だけでできることを試してみた。


一番簡単な例
============

簡単な画像を生成する例は次の通り。1つ点を打つだけの例。

```go
package main

import "image"
import "image/color"
import "image/png"
import "os"

func main() {
    // 100×50 の画像を作成する
    img := image.NewRGBA(image.Rect(0, 0, 100, 50))

    // (2, 3) に赤い点をうつ
    img.Set(2, 3, color.RGBA{255, 0, 0, 255})

    // out.png に保存する
    f, _ := os.OpenFile("out.png", os.O_WRONLY|os.O_CREATE, 0600)
    defer f.Close()
    png.Encode(f, img)
}
```


もっと複雑な例
==============

こんな画像を生成してみる。

<center><img src="rgb1.png" width="280" height="240"></center>

コードはこうなった。

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

`Circle` 構造体を定義して、円の中に入っているかどうかを判定する処理をメソッドとして定義している。

ちょっとしたテクニックとして、色を決定する部分は次のようにしている。

```go
c := color.RGBA{
    cr.Brightness(float64(x), float64(y)),
    cg.Brightness(float64(x), float64(y)),
    cb.Brightness(float64(x), float64(y)),
    255,
}
```

赤い色の中のときは赤色成分は `255`、外のときは `0` としている。他の成分も同じ。


周辺をぼかしてみる
==================

色がくっきりしすぎているので、画像の周りをぼかしてみた。

<center><img src="rgb2.png" width="280" height="240"></center>

円の中のときに `return 255` としていた部分を書きかえるだけでできた。

```go
func (c *Circle) Brightness(x, y float64) uint8 {
    var dx, dy float64 = c.X - x, c.Y - y
    d := math.Sqrt(dx*dx+dy*dy) / c.R
    if d > 1 {
        // 円の外のとき
        return 0
    } else {
        // 円の中のとき
        return uint8((1 - math.Pow(d, 5)) * 255)
    }
}
```

`math.Pow` で 5 乗しているのは、ぼけすぎないようにするための工夫。
