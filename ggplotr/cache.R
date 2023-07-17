
## 探索性数据分析

在画图之前你应该先对数据有基本的了解. 可视化基本解决两个问题: 1) 变量的分布; 2) 变量与变量之间的关系。前面我们在`tidyr`那个部分学过, 在画图前, 确保你画图中涉及的每一个数据点都在单独的单元格里, 每个变量有自己单独的列，每个观测有自己单独的行. 

科学研究包含两个过程: 探索和假设检验. 首先我们通过探索性数据分析提出要被检验的假设. 然后，使用专门的统计工具来证实针对(没有见到过的)数据的假设是否依然成立. 所以我们学习可视化的一个重要目的就是发掘数据的特征并提出一堆基于可视化结果的假设

### 数据分布

首先我们要弄清涉及这个分布的变量是连续值还是离散值. 离散值在`r R`中一般是字符串类型(character)或者因子类型(factor). 而连续变量[^1]在`r R`中一般是数值型(numeric)或者时间类型(date-times)

```{r, collapse=TRUE}
mpg %>% glimpse()
```

```{r}
mpg %>% ggplot() +
  geom_bar(aes(x = class)) + 
  labs(title="离散变量: 车型(class)") + 
  scale_x_discrete(guide = guide_axis(angle = 45)) -> a

mpg %>% ggplot() +
  geom_histogram(aes(x = displ), binwidth = 0.1) + 
  labs(title="连续变量: 发动机排量(displ)") -> b

a + b
```

[^1]: 如果将连续变量的值进行排序, 任意两个数据点之间存在无限多个值, 例如0.9到1之间存在0.91, 0.99, 0.999等无限多个可能的值

在上面的条形图(`geom_bar`)和直方图(`geom_histogram`)中, 注意y轴代表频次(count). 也就是说值越高, 代表某个或某些值(区间)出现的越频繁. 有了这个频次分布图, 我们可以提出以下问题: 

1. 哪些值最常见, 为什么这样
2. 哪些值比较稀有, 为什么这样
3. 这个分布是否符合预期, 是否存在异常值, 即距离其他数据点比较远的点

对于连续变量而言(x轴连续), 你可能会注意到分布具有一些明显的特征。

```{r, echo = F}
ggplot(data = faithful) +
  geom_histogram(aes(x = eruptions), binwidth = 0.25) + 
  labs(title="黄石公园 Old Faith 火山272次喷发的持续时间 (单位: 分钟)")
```

我们先搞清楚`x`和`y`轴分别代表什么, 这里`x`显示每次喷发的持续时间, 可以看到最短持续约一分钟，最长持续约五分钟. 然后`y`显示在某个时间范围内(例如2分钟-2分钟15秒)的观测次数, 或者说历史上有30次该火山喷发的持续时间在2分钟至2分钟15秒左右. 

### 双变量

当你希望发现两个变量之间的关系(例如相关关系), 同样要区分变量是连续还是离散

```{r, fig.height = 2}
ggplot2::diamonds %>% count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n)) -> a

ggplot2::diamonds %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_count() -> b

(a + b) + patchwork::plot_annotation(
  title = "离散+离散: 53940颗钻石的颜色与切工质量的关系"
)
```

```{r, fig.height = 2}
ggplot(data=mpg) +
  geom_boxplot(
    mapping = aes(x = reorder(x=class, X=hwy, FUN=median), y = hwy)
  ) +
  labs(x = "class", title = "离散+连续: 不同车型的高速油耗") -> a

ggplot(data=mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy)
  ) + 
  labs(title = "连续+连续: 发动机排量和高速油耗的关系") -> b

a + b
```

根据变量类型的不同, 在可视化之前先确定你关心的变量类型:

```{r echo=FALSE, fig.align='center'}
add_img('plots-table.png')
```


## 单变量

### 条形图

添加`geom_bar`图层到`ggplot()`对象中, 注意`+`而不是`%>%`

```{r, fig.align='center'}
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut)) -> a

count <- diamonds %>% count(cut)
ggplot(data = count) + 
  geom_bar(mapping = aes(x = cut, y = n), stat='identity') -> b

ggplot(data = count) + 
  geom_col(mapping = aes(x = cut, y =n)) -> c

(a + b + c) + 
  patchwork::plot_annotation( title = "不同钻石切工质量的计数分布")
```

如果你输入`?geom_bar`会发现

```{r echo=FALSE, fig.align='center', out.width = "60%"}
add_img('geom_bar.png')
```

也就是说你必须提供`x`轴和`y`轴的映射, `r R`才明白怎么作图. 可这里我们并没有指示`y`轴应该填入什么信息呀? 事实上它会在拿到`x`的信息后, 计算每一个`x`出现的次数, 并返回`after_stat(count)`作为`y`轴的默认值. 你也可以像右边这样先手动计数, 然后填入`x`和`y`轴的映射信息. 但你可能注意到我把`stat`参数由原来的`stat=count`换成了`stat=identity`. ggplot直接将后者封装成了`geom_col`函数

`r E` 使用上面三种条形图方式画出不同钻石颜色的计数分布

```{r bex1, exercise = TRUE}

```

```{r bex1-hint}
ggplot(data = diamonds) + geom_bar(mapping = aes(x = color))
```

另外你可以通过`width`参数来控制每一个条块的宽度, 比如把之前的条形图换成`width=0.1`看一看结果发生了什么改变

```{r bex2, exercise = TRUE}

```

```{r bex2-hint}
ggplot(data = diamonds) + geom_bar(mapping = aes(x = color), width=0.1)
```

`r Q`: 想一想, 如果将`width = 0.1`写到`aes()`函数里会发生什么

### AES

在`geom_bar`和`geom_col`中你还可以通过设置不同的alpha(透明度), color(颜色), fill(填充色), linetype(线条形状), size(大小尺寸)来控制图形输出的样式

```{r bex3, exercise = TRUE}
# 用颜色区分不同切工
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, color = cut))
```

### Position参数

前面讲了`width`参数能控制每一个条形块的宽度, `position`则能够控制同一个`x`却属于不同组别的条形块如何堆叠. 

比如下面这四种堆叠方式: identity(重叠), fill(堆叠但顶部都是100%), stack(堆叠), dodge(并行排列)

```{r, fig.align='center', fig.height=4}
a <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position='stack') + labs('stack') +
  theme(legend.position = "none")
b <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position='dodge') + labs('dodge') +
  theme(legend.position = "none")
c <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position='fill') + labs('fill') +
  theme(legend.position = "none")
d <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position='identity') + labs('identity') +
  theme(legend.position = "none")

((a + b) / (c + d)) + 
  patchwork::plot_annotation( title = "不同纯度钻石的切工质量的计数分布")
```

`r E`: 如何复现下面这张图

```{r, echo = F, fig.height=2}
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color, fill = clarity), position = "fill")
```

```{r bex4, exercise = TRUE}

```

```{r bex4-solution}
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color, fill = clarity), position = "fill")
```

### Facetting

除了堆叠这种避免数据拥挤的方式外, 我们还可以制作子图来分割不同组别的数据. 你可以通过`facet_grid()`或`facet_wrap()`来分面. 

- `facet_grid`通过`rows`和`cols`参数将图垂直分割为小平面, 每个特定的子图显示特定的行列组合
- `facet_wrap()` 提供了一种更简单的方法对图进行分面, 它将把图分成子图，然后将子图重新组织成多行(通过`nrow`, `ncol`实现)

`r E`: 按照纯度(行)-切工质量(列)制作不同钻石颜色的频数分布图, 注意引用变量使用`"变量名"`或者`vars(变量名)`

```{r bex5, exercise = TRUE}

```

```{r bex5-solution}
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color)) +
  facet_grid(rows=vars(clarity), cols=vars(cut))
```

`r E`: 按照纯度制作不同钻石颜色的频数分布图, 要求使用`facet_wrap`函数实现

```{r bex6, exercise = TRUE}

```

```{r bex6-solution}
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color)) +
  facet_wrap(vars(clarity))
```

### 直方图

前面讲过, 条形图适用于统计离散变量的计数, 而直方图适用于连续变量的计数. 它本质上是通过`bin`函数统计每一个小区间里观测的数目, 然后问题就变成了之前学习的如何描绘离散变量的计数分布. 

这些参数可以帮助你定义区间:

- binwidth: 默认情况下, 会自动选择一个`binwidth`从而产生大约30个条形块
- bins: 产生多少个条形块
- boundary: 设置两个条形块之间的间距

:::: two-col
::: {}
`r E`: 描绘不同切工质量的钻石价格计数分布, 产生50个条形块, 使用默认堆叠方式, 条形块间距为0
:::
::: {}
```{r histogram, echo = FALSE}
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price, fill = cut), bins = 500, boundary = 0)
```
:::
::::

```{r bex7, exercise = TRUE}

```

现在这个图很难看出各个分布的形状, 我们可以使用堆叠的方式(position=dodge), 但还是太拥挤了. 除了分面以外, 我们还可以使用不同的几何图形显示不同切工钻石价格的分布. 

- geom_freqpoly() 绘制频率多边形, 和直方图显示的信息一样, 只是用线条表示。等于用一条线连接每一个条形顶部. 注意我把AES从`fill`改成了`color`
- geom_density() 绘制每个分布的核密度曲线, 相当于平滑的直方图. 统计指标不是用计数(count)而是密度(count/total)


```{r, fig.height=2}
ggplot(data = diamonds) +
  geom_freqpoly(
    mapping = aes(x = price, color = cut), binwidth = 500, boundary = 0
  ) -> a

ggplot(data = diamonds) +
  geom_density(
    mapping = aes(x = price, color = cut)
  ) -> b

(a + b) + patchwork::plot_annotation( title = "不同切工质量的钻石价格的计数分布")
```


## 双变量

### 箱图

箱图展示了更多的统计信息, 包括中位数, 分位数, 奇异值等.

```{r}
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y=hwy)) +
  coord_flip() +
  labs(title = "不同车型的高速油耗")
```

如果你不希望看到奇异值出现在图形中, 可以通过设定`outlier.alpha=0`来实现

```{r outliers, exercise = TRUE}
ggplot(data = diamonds) +
  geom_boxplot(
    mapping = aes(x = cut, y = price), 
    outlier.shape  = 24, outlier.fill = "white", outlier.stroke = 0.25
  )
```

:::: two-col
::: {}
当`x`轴是连续值的时候, 箱图并不会自动切分, 你必须定义`group`映射

你可以使用如下三种将连续变量离散化的方式

1. `cut_interval()` 使 n 个组具有相等的长度
2. `cut_number()` 使 n 个组具有（大约）相等的观测
3. `cut_width()` 使组的宽度固定为width
:::
::: {}
```{r histogram, echo = FALSE}
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = carat, y = price))
```
:::
::::

```{r, collapse=T}
x <- 1:10
cut_interval(x, n = 3)
cut_number(x, n = 5)
cut_width(x, width = 3)
```

将钻石重量(克拉)进行离散化, 每0.5的区间作为一个箱, 得到箱型图

```{r r4, exercise = TRUE, exercise.eval = TRUE}
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = carat, y = price))
```

```{r r4-solution}
ggplot(data = diamonds) +
  geom_boxplot(
    mapping = aes(x = carat, y = price, group = cut_width(carat, width = 0.5))
  )
```

另外两种表示离散-连续变量分布的函数也很常用, 他们是`geom_dotplot`和`geom_violin`

- `geom_dotplot`: 如果将`binaxis`参数设置为"y", geom_dotplot() 将和 geom_boxplot() 一样给每组数据显示单独的分布
- `geom_violin`: 则使用密度函数绘制`dotplot`的平滑轮廓版本. 数值多的地方小提琴就厚，数值少的地方就薄

```{r, fig.align='center', fig.height=2}
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy)) +
  coord_flip() + labs(x=NULL) -> a

ggplot(data = mpg) +
  geom_dotplot(
    mapping = aes(x = class, y = hwy), binaxis = "y", 
    dotsize = 0.5, binwidth = 1
  ) +
  coord_flip() + labs(x=NULL)  -> b

ggplot(data = mpg) +
  geom_violin(
    mapping = aes(x = class, y = hwy),
    draw_quantiles = c(0.25, 0.5, 0.75)
  ) +
  coord_flip() + labs(x=NULL)  -> c

(a + b + c) + 
  patchwork::plot_annotation( title = "不同车型的高速油耗")
```

### 热点图

如果两个变量都是离散的话, 除了人为切分, 你也可以使用`geom_count`和`geom_tile`来绘制两个离散变量的交互

- `geom_count`: 在两两交汇的地方计数, 统计频次, 点的大小反映出现次数, 越大代表出现次数越多
- `geom_tile`: 使用填充色来反映计数频次的大小

```{r, fig.height=2}
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = clarity)) -> a

diamonds %>% count(cut, clarity) %>% 
  ggplot() +
  geom_tile(mapping = aes(x = cut, y = clarity, fill = n)) -> b

(a + b) + 
  patchwork::plot_annotation( title = "不同切工和不同纯度之间的关系")
```

### 散点图

```{r, fig.align='center', fig.height=5}
mpg %>% 
  group_by(class) %>% 
  summarise(cty = mean(cty), hwy = mean(hwy)) -> data

a <- ggplot(data = data, mapping = aes(x=cty, y=hwy)) + 
  geom_point() + labs('point')

b <- ggplot(data = data, mapping = aes(x=cty, y=hwy)) + 
  geom_jitter() + labs('jitter')

c <- ggplot(data = data, mapping = aes(x=cty, y=hwy)) + 
  geom_text(mapping = aes(label = class)) + labs('text')

d <- ggplot(data = data, mapping = aes(x=cty, y=hwy)) + 
  geom_label(mapping = aes(label = class)) + labs('label')


((a + b) / (c + d)) + 
  patchwork::plot_annotation( title = "高速油耗 ~ 城市油耗")
```

```{r bex7, exercise = TRUE}
```

我们可以添加`geom_smooth`用一根平滑曲线来拟合这些散点, 从而更好地分析趋势. 当数据集观测大于1000时, 他默认使用广义线性模型来拟合这些散点. 我们也可以在`method`参数那里规定拟合的算法.

`r E`: 请给上面的散点增加一个线性拟合曲线(method=lm)

```{r prep-data}
mpg %>% 
  group_by(class) %>% 
  summarise(cty = mean(cty), hwy = mean(hwy)) -> data
```

```{r bex8, exercise = TRUE, exercise.setup="prep-data"}
data
```

### 图层

就像前面我们将散点和平滑拟合曲线组合, 图形的信息量立马丰富了许多一样. 通常一个ggplot都含有超过一个图层. 

例如我们可以使用`ggrepel::geom_label_repel`函数来给数据点增加文本标签

```{r bex9, exercise = TRUE, exercise.setup="prep-data"}
ggplot(data) +
    geom_point(mapping = aes(x = cty, y = hwy)) +
    geom_smooth(mapping = aes(x = cty, y = hwy), method = lm) +
    ggrepel::geom_label_repel(mapping = aes(x = cty, y = hwy, label = class))
```

我们需不需要在每一个图层里都指定`x`和`y`轴的映射信息呢? 答案是不需要, 他们可以直接继承ggplot()对象里的全局映射. 

```r
ggplot(data) + aes(x = cty, y = hwy)
```

- ggplot2 会将 ggplot() 函数中设置的任何映射视为全局映射. 图中的每一层都将继承并使用这些映射. 
- ggplot2 会将 geom 函数中设置的任何映射视为局部映射. 只有该图层才会使用这些映射. 这个映射不会影响其他图层. 

请把前面那个代码重写, 尽量继承全局映射而不要重复写局部映射


```{r bex10, exercise = TRUE, exercise.setup="prep-data"}
ggplot(data) +
    geom_point(mapping = aes(x = cty, y = hwy)) +
    geom_smooth(mapping = aes(x = cty, y = hwy), method = lm) +
    ggrepel::geom_label_repel(mapping = aes(x = cty, y = hwy, label = class))
```

跟映射(AES)一样的还有数据(data), 我们也可以定义局部图层专属数据. 比如下面这个例子

```{r local-data, exercise=TRUE}
mpg3 <- filter(mpg, hwy > 40)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  ggrepel::geom_label_repel(data = mpg3, mapping = aes(label = class))
```

### 折线图

当`x`和`y`都是连续值的时候, 我们习惯用折线图反映两个连续变量之间的关系. 

```{r, fig.align='center', fig.height=2}
ggplot(data = mpg, mapping=aes(x = displ, y = hwy)) + 
  geom_line() -> a

ggplot(data = mpg, mapping=aes(x = displ, y = hwy)) + 
  geom_step() -> b

ggplot(data = mpg, mapping=aes(x = displ, y = hwy)) + 
  geom_area() -> c

(a + b + c) + 
  patchwork::plot_annotation( title = "发动机排量和高速油耗的关系")
```

你也可以添加分组映射(group)来给不同组别的观测绘制单独的折现, 不过建议使用颜色, 形状这种视觉冲击强的元素作为分组映射的目标

```{r bex11, exercise=TRUE}
ggplot(data = mpg, mapping=aes(x = displ, y = hwy, group=drv)) + 
  geom_line() -> a

ggplot(data = mpg, mapping=aes(x = displ, y = hwy, color=drv)) + 
  geom_step() -> b

(a + b) + 
  patchwork::plot_annotation( title = "不同驱动类型: 发动机排量和高速油耗的关系")
```
