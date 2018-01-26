
![gif](https://github.com/RealMeZJT/LongPressToMoveCellDemo/blob/master/demo.gif)

受到这篇文章的指导: https://www.raywenderlich.com/63089/cookbook-moving-table-view-cells-with-a-long-press-gesture

# 思路
1. 长按 cell 的时候，获取该cell的“快照”，同时隐藏该cell；
2. “快照”随着手指的位置移动，让用户看起来像是真的cell在随手指移动；
3. 如果“快照”到达其它cell的位置，那么，交换它们的位置；
4. 手指松开后，“快照”移除，同时原cell显示出来。

