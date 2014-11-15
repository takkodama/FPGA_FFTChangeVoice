# FPGA_FFTChangeVoice

 [筑波大学情報学群 組み込み技術キャンパスOJT](http://inf.tsukuba.ac.jp/ET-COJT/) [ハードウェアコース](http://inf.tsukuba.ac.jp/ET-COJT/curriculum/) 4期の自由課題にて開発した、FPGA回路上で動作するボイスチェンジャー

## Features

- 音声をマイクから入力⇒変換し、リアルタイムで面白ボイスを再生する
- 自身の声を高いピッチ、低いピッチに変更して聞く事が可能
- 音声の変換には高速フーリエ変換(FFT)を適用した

## Specifications

**FFTをハードウェア化するために、FFT計算行列を回路で実現する**
![](https://raw.githubusercontent.com/shartsu/FPGA_FFTChangeVoice/master/images/s1.png)

**バタフライ演算(N=4)を用いて実装を行った**
![](https://raw.githubusercontent.com/shartsu/FPGA_FFTChangeVoice/master/images/s2.png)

**回路全体図**
![](https://raw.githubusercontent.com/shartsu/FPGA_FFTChangeVoice/master/images/c1.png)

**回路内部の設計図**
![](https://raw.githubusercontent.com/shartsu/FPGA_FFTChangeVoice/master/images/c2.png)

**ステートマシン設計図**
![](https://raw.githubusercontent.com/shartsu/FPGA_FFTChangeVoice/master/images/c3.png)

## Presentation Movie

**筑波大学COJT第4期ハードエンジニアリング分野成果発表会**

* 10:31~

[![IMAGE ALT TEXT HERE](https://raw.githubusercontent.com/shartsu/FPGA_FFTChangeVoice/master/images/mov.png)](https://www.youtube.com/watch?v=R6EtG7UaVgo#t=10m31s)

## Operating environment
-  [ハードウェアコース カリキュラム](http://inf.tsukuba.ac.jp/ET-COJT/curriculum/)  を参照

## License
- CC by 3.0

## Acknowledgments
- [Verilog: FFT With 32K-Point Transform Length](http://www.altera.com/support/examples/verilog/ver-fft-32k.htmlt)
- [筑波大学情報学群 組み込み技術キャンパスOJT カリキュラム](http://inf.tsukuba.ac.jp/ET-COJT/curriculum/)
- [ハードにできることはハードでやる、それが僕らのこだわり
僕らがリアルなものづくりを志したワケ - 日経テクノロジーオンライン](
http://techon.nikkeibp.co.jp/article/COLUMN/20141028/385300/)