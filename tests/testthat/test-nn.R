context("nn2")

test_that("basic use of nn2", {

  res<-structure(
    list(
      nn.idx = structure(c(1L, 2L, 2L),
                         .Dim = c(3L, 1L)),
      nn.dists = structure(c(0.01, 1, 2),
                           .Dim = c(3L, 1L))),
    .Names = c("nn.idx", "nn.dists"))
  
  res.func<-nn2(rbind(c(1,0),c(2,0)),rbind(c(1.01,0),c(3,0),c(4.0,0)),k=1)
  expect_equal(res,res.func)
  
  a=structure(c(-0.626453810742332, 0.183643324222082, -0.835628612410047, 
                1.59528080213779, 0.329507771815361, -0.820468384118015, 0.487429052428485, 
                0.738324705129217, 0.575781351653492, -0.305388387156356, 1.51178116845085, 
                0.389843236411431, -0.621240580541804, -2.2146998871775, 1.12493091814311, 
                -0.0449336090152309, -0.0161902630989461, 0.94383621068530, 0.821221195098089, 
                0.593901321217509, 0.918977371608218, 0.782136300731067, 0.0745649833651906, 
                -1.98935169586337, 0.61982574789471, -0.0561287395290008, -0.155795506705329, 
                -1.47075238389927, -0.47815005510862, 0.417941560199702), .Dim = c(10L, 
                                                                                   3L))
  
  b=structure(c(1.35867955152904, -0.102787727342996, 0.387671611559369, 
                -0.0538050405829051, -1.37705955682861, -0.41499456329968, -0.394289953710349, 
                -0.0593133967111857, 1.10002537198388, 0.763175748457544, -0.164523596253587, 
                -0.253361680136508, 0.696963375404737, 0.556663198673657, -0.68875569454952, 
                -0.70749515696212, 0.36458196213683, 0.768532924515416, -0.112346212150228, 
                0.881107726454215, 0.398105880367068, -0.612026393250771, 0.341119691424425, 
                -1.12936309608079, 1.43302370170104, 1.98039989850586, -0.367221476466509, 
                -1.04413462631653, 0.569719627442413, -0.135054603880824), .Dim = c(10L, 
                                                                                    3L))
  
  nearest=structure(
    list(
      nn.idx = structure(
        c(7L, 7L, 5L, 8L, 3L, 3L, 10L,
          9L, 7L, 9L, 2L, 6L, 10L, 9L, 6L, 2L, 6L, 8L, 2L, 7L, 10L, 3L, 
          2L, 10L, 2L, 10L, 7L, 10L, 5L, 8L, 5L, 9L, 9L, 7L, 10L, 6L, 9L, 
          7L, 10L, 5L, 9L, 10L, 7L, 2L, 1L, 1L, 2L, 5L, 9L, 10L),
        .Dim = c(10L, 5L)),
      nn.dists = structure(c(1.57348521932759, 1.28361908335448, 
                             0.764837438952666, 1.52069204554225, 1.96740477676213, 2.41272354067135, 
                             1.10338396230088, 1.25376759015526, 1.43426740275442, 0.590376379387974, 
                             2.11343348033597, 1.48200638161807, 0.87294392167823, 1.545357429633, 
                             2.68956569947493, 2.89423987867011, 1.14678673849724, 1.39955914559303, 
                             1.63098816961211, 1.19378558840672, 2.44232853598913, 1.78731116208831, 
                             0.952165035637235, 1.8361261253978, 3.29018921298162, 2.97346099262911, 
                             1.47391720113579, 1.88278278025931, 2.05790085091415, 1.42327730757786, 
                             2.54034616163802, 1.88702829237324, 1.13163730632052, 2.08765514415945, 
                             3.36941032694062, 3.10456400680008, 1.53763911696721, 2.21980475636523, 
                             2.26343935975068, 1.43237152010661, 2.64489892670291, 2.07983161461785, 
                             1.30982627750255, 2.31576772387907, 3.46518893917947, 3.49215809975326, 
                             1.75255232940461, 2.40917953636548, 2.50568111012974, 1.90876670493113
      ),
      .Dim = c(10L, 5L))),
    .Names = c("nn.idx", "nn.dists"))
  
  expect_equal(nn2(a, b, k=5), nearest, tol=1e-6)
})

# NB this fails with the version of ANN distributed with knnFinder v1.0
test_that("nn2 with identical point", {
  res<-structure(
    list(
      nn.idx = structure(c(1L, 2L, 2L),
                         .Dim = c(3L, 1L)),
      nn.dists = structure(c(0, 1, 2),
                           .Dim = c(3L, 1L))),
    .Names = c("nn.idx", "nn.dists"))
	
	res.func<-nn2(rbind(c(1,0),c(2,0)),rbind(c(1.0,0),c(3,0),c(4.0,0)),k=1)
	expect_equal(res,res.func)
})


test_that("nn2 with different search / tree types", {
	set.seed(1)
	a=matrix(rnorm(3000),ncol=3)
	b=matrix(rnorm(3000),ncol=3)
	n.standard<-nn2(a,b,k=5,searchtype='standard')
	n.priority<-nn2(a,b,k=5,searchtype='priority')
	n.bd.standard<-nn2(a,b,k=5,searchtype='standard',treetype='bd')
	n.bd.priority<-nn2(a,b,k=5,searchtype='priority',treetype='bd')

	expect_equal(n.standard,n.priority)
	expect_equal(n.standard,n.bd.standard)
	expect_equal(n.standard,n.bd.priority)
})

test_that("nn2 fixed radius with large radius", {
	set.seed(1)
	a=matrix(rnorm(3000),ncol=3)
	b=matrix(rnorm(3000),ncol=3)
	n.standard<-nn2(a,b,k=5,searchtype='standard')
	n.rad<-nn2(a,b,k=5,searchtype='radius',radius=20.0)
	n.bd.rad<-nn2(a,b,k=5,searchtype='radius',radius=20.0,treetype='bd')

	expect_equal(n.standard,n.rad)
	expect_equal(n.standard,n.bd.rad)
})

test_that("matrix with 0 columns", {
  d=matrix(ncol=0,nrow=90)
  expect_error(nn2(d))
})

test_that("all NA", {
  data=matrix(rnorm(10), ncol=2)
  query=matrix(rep(NA_real_,10), ncol=2)
  expect_error(nn2(data = data, query = query, k=1))
})

test_that("mixture of matrix and vector inputs", {
  mat=matrix(rnorm(10), ncol=1)
  vec=as.numeric(mat)
  expect_is(res<-nn2(data = mat, query = vec, k=1), 'list')
  expect_equal(nn2(data = vec, query = mat, k=1), res)
  expect_equal(nn2(data = vec, query = vec, k=1), res)
})

test_that("vector inputs give outputs of appropriate length", {
  expect_is(res<-nn2(data = rnorm(10), query = rnorm(5), k=1), 'list')
  expect_equal(length(res$nn.idx), 5L)
})

test_that("inputs with different dimensions", {
  mat=matrix(rnorm(20), ncol=2)
  vec=as.numeric(mat[,1])
  expect_error(nn2(data = mat, query = vec, k=1), 'same dimensions')
})
