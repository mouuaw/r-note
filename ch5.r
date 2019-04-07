# 02 sql을 사용한 데이터 처리

install.packages("sqldf")
library(sqldf)

sqldf("select distinct Species from iris")
sqldf('select "Sepal.Length" from iris where Species="setosa"' )

sqldf('select avg("Sepal.Length") from iris where Species="setosa"')

# 03 분할, 적용, 재조합을 통한 데이터 분석

install.packages("plyr")
library(plyr)


apply(iris[, 1:4], 1, function(row) { print(row) })

ddply(iris,.(Species),function(sub) {
  data.frame(sepal.width.mean=mean(sub$Sepal.Width))
})

# mdply()
# 평균과 표준편차를 저장한 데이터 프레임을 만든다
(x <- data.frame(mean=1:5, sd=1:5))

# reshape2
install.packages("reshape2")
library(reshape2)

head(french_fries)

m <- melt(french_fries, id.vars=1:4)
head(m)
library(plyr)
ddply(m, .(variable), summaries, mean=mean(value, na.rm=TRUE))

# 05 데이터 테이블
install.packages("data.table")
library(data.table)

# key를 사용한 데이터 병합
DT1 <- data.table(x=runif(260000),
  y=rep(LETTERS, each=10000))
DT2 <- data.table(y=c("A", "B", "C"), z=c("a", "b", "c"))

setkey(DT1, y) # DT1 에서의 검색을 빠르게 하기 위한 색인 생성
DT1[DT2,]

# 참조를 사용한 데이터 수정
m <- matrix(1, nrow=1000, ncol=100)
DF <- as.data.frame(m)
DT <- as.data.table(m)

system.time({
  for (i in 1:1000) {
    DF[i, 1] <- i
  }
})

system.time({
  for (i in 1:1000) {
    DT[i, V1 := i]
  }
})

# 리스트를 데이터 프레임으로 변환하기
library(plyr)

system.time(x <- ldply(1:10000, function(x) {
  data.frame(val = x,
            val2 = 2 * x,
            val3 = 2 / x,
            val4 = 4 * x,
            val5 = 4 / x)
}))

system.time(x <- llply(1:10000, function(x) {
  data.frame(val = x,
            val2 = 2 * x,
            val3 = 2 / x,
            val4 = 4 * x,
            val5 = 4 / x)
}))

# 더 나은 반복문
install.packages("foreach")
library(foreach)
foreach(i= 1:5) %do% {
    return(i)
}

foreach(i=1:5, .combine=c) %do% {
  return (i)
}

foreach(i=1:5, .combine=rbind) %do% {
  return(data.frame(val=i))
}

# 병렬 처리
install.packages("doParallel")
library(doParallel)
library(plyr)

registerDoParallel(cores=4)

big_data <- data.frame(
  value=runif(NROW(LETTERS) * 2000000),
  group=rep(LETTERS, 2000000)
)

dlply(big_data, .(group), function(x) {
  mean(x$value)
},
.parallel=TRUE)

library(foreach)

# 유닛 테스팅과 디버깅
install.packages("testthat")
library(testthat)