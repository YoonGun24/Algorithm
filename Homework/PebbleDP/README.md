# 조약돌 놓기 — Processing

Processing Java Mode에서 `PebbleDP.pde`를 열고 실행합니다. 외부 라이브러리는 필요 없습니다.

3행 보드에 가로·세로로 인접하지 않게 조약돌을 놓는 네 가지 상태의 DP를 시각화합니다. 원본처럼 매 열에는 조약돌을 하나 이상 놓습니다. 음수 값이 있어도 빈 열 상태는 추가하지 않았습니다.

- S1: 위쪽 / S2: 가운데 / S3: 아래쪽 / S4: 위쪽 + 아래쪽
- 이전 열의 호환 상태 중 최댓값에 현재 상태의 값을 더합니다.
- 마지막에는 최적 경로를 역추적하여 보드와 DP 표에 초록색으로 표시합니다.
- 예제 최대합: **81**

`value` 배열을 수정하면 입력을 바꿀 수 있습니다. 화면의 숫자 가독성을 위해 1~6열을 권장합니다. 계산에는 `long`을 사용합니다. 시간·공간 복잡도는 O(n)입니다.

## 조작

- Space: 일시정지 / 재생
- 오른쪽 화살표: 다음 계산 단계
- R: 처음부터 재생
- G: 처음부터 PNG 프레임 내보내기 (`frames` 폴더)

## GIF 만들기

내보내기가 끝난 뒤 스케치 폴더에서 FFmpeg로 변환합니다. 매 프레임을 모두 저장하므로 실제 내보내기 속도와 관계없이 GIF는 15fps로 재생됩니다. 다시 내보낼 때에는 기존 `frames` 폴더를 비워 오래된 프레임이 섞이지 않게 합니다.

```sh
ffmpeg -y -framerate 15 -i frames/pebble-%04d.png -filter_complex "[0:v]scale=1120:800:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=sierra2_4a" -loop 0 PebbleDP.gif
```

실제 Processing 런타임 실행 및 302개 사례의 완전탐색 비교를 통해 계산 결과와 역추적 경로를 확인했습니다.
