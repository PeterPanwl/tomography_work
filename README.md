# tomography_work

**说明**

这个项目的目的是在已知地震目录的情况下，处理seed格式的事件数据，拾取直达纵波和直达横波的到时。

## 文件含义
以后再写

## 如何使用
1. 将本项目的目录即tomography_work和seed格式文件、地震目录放在一个目录(下称为work)下。
2. 执行build.pl，为每个地震在work下建立工作目录(下称为$id)，在work下生成记录有哪些$id的directories文件。每个$id目录都是tomography_work目录的复制。seed文件会被移动到对应的$id下。$id下会建立文本文件info保存地震的事件信息。目前的build.pl是适合我的地震目录和seed文件的，你需要根据你的目录的格式和seed文件的命名格式修改build.pl。需要注意：保存到info内的地震事件信息必须是yyyy-mm-ddThh:mm:ss.xxx evla evlo evdp mag样式的，否则你需要修改后面的脚本。我习惯将$id命名为事件id，也许你喜欢用发震时刻来命名，这也需要修改build.pl改变$id的意义。$id的列表要保存到directories文件中，一行一个，后续的脚本要根据这个文件的内容去批量地执行脚本处理数据。
3. $id/process下，执行process.pl就会预处理数据。process.pl会调用其他脚本进行数据处理。需要指出的是eventinfo.pl是标记事件信息，信息的内容如上一条所说要正确的写到info文件中。wave.pl是对波形进行修改，这个脚本会使用$id目录下的configure文件内的内容来执行，如果用户没有这个文件或者没有相应内容则不会对数据进行任何改动。wave.pl会读取configure文件内的每一行，例如有一行是"WAVE:bp c 2 9 n 2 p 1",则会对数据进行"bp c 2 9 n 2 p 1"。taup.pl会标记理论到时，Pn标到t7，P、p初动标在t8，S，s波初动标到t9。$id/process.md会记录脚本运行的一些情况。
4. 如果想要批量地预处理数据，可以用tomography_work或者任一$id下的go.pl，这个脚本会读取directories文件的内容，然后进入相应目录执行process.pl。
5. 到时标定时，请遵循原则：t1是纵波，t2是横波，如果两个都无法确定，则在随便一处标记t4。
6. 运行tomography_work或者任一$id下的time.pl，则会去提取所以地震的到时信息保存到文件在work/time.txt中，time.pl依然依赖directories文件去进入各个目录，如果t1、t2、t4都没有标记，则认为标定错误，错误的信息会保存在work/time.md中。

## 版权问题
本项目部分代码大量借用了[SAC中文手册](https://github.com/seisman/SAC_Docs_zh)的中的脚本。

包括上述借用的部分，本项目中的全部内容遵循 [**CC0 1.0 通用 (CC0 1.0)**](https://creativecommons.org/publicdomain/zero/1.0/deed.zh) 许可协议。
即所有脚本放弃一切权利，全归公共领域。任何人可以自由无限制地使用、修改、共享本项目中的脚本。
当然，作者也不对脚本的品质、安全性做任何担保。

QQ： 1007274631

EMAIL： wangliang0222@foxmail.com
