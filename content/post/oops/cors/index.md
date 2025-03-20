---
title: "CORS踩坑记录"
description: 学艺不精啊
date: 2025-03-06T21:12:09+08:00
fullpage: 
toc: 
hidden: false
notify: false
comments: 
categories: 
  - oops
tags: 
draft: false
---
> Cross-origin resource sharing（CORS，或通俗地译为跨域资源共享）是一种基于HTTP 头的机制，该机制通过允许服务器标示除了它自己以外的其他源（域、协议或端口），使得浏览器允许这些源访问加载自己的资源

## 同源策略

用于限制一个源的文档或者它加载的脚本如何能与另一个源的资源进行交互。

只有满足以下条件的请求才是同源的：

1. 协议相同（file://被视作非同源，无论路径是否一致，但某些浏览器处理方式可能不同）
2. 域名相同
3. 端口相同

出于安全性，浏览器限制脚本内发起的跨源 HTTP 请求。例如，XMLHttpRequest 和 Fetch API 遵循同源策略。这意味着使用这些 API 的 Web 应用程序只能从加载应用程序的同一个域请求 HTTP 资源，除非响应报文包含了正确 CORS 响应头。

## CORS 响应头

```http
Access-Control-Allow-Origin: <origin> | *
```

告诉浏览器允许那些源访问资源，*表示允许所有源访问

```http
Access-Control-Expose-Headers: <header-name>[, <header-name>]*
```

告诉浏览器哪些响应头可以暴露给外部脚本，默认情况下，浏览器不允许外部脚本访问响应头，除非响应头中包含 `Access-Control-Expose-Headers` 头，并且该头中包含要暴露的响应头名称。

```http
Access-Control-Allow-Methods: <method>[, <method>]*
```

允许的请求方法，默认情况下，浏览器不允许外部脚本发起除 GET、HEAD、POST *(简单请求)* 外的请求，除非响应头中包含 `Access-Control-Allow-Methods` 头，并且该头中包含要允许的请求方法名称。

```http
Access-Control-Allow-Headers: <header-name>[, <header-name>]*
```

用于预检请求的响应。其指明了实际请求中允许携带的标头字段。
这个标头是服务器端对浏览器端 Access-Control-Request-Headers 标头的响应。

## 踩坑

在执行跨域请求的时候，其实并不是只需要设置预检请求的响应头，还需要设置实际的请求的响应头。
拿保安和办公室举个例子：当你进别的公司办事时需要问保安，还需要里面的人同意

本来如果要用插件的话应该会帮你处理好这些，但是我在用goproxy做一些mitm妙妙操作，所有请求都需要自己处理
折腾了半天才发现是只对OPTIONS做了添加请求头处理😭

```go
func (p *proxyContext) makeProxyServer() *goproxy.ProxyHttpServer {
   proxy := goproxy.NewProxyHttpServer()
   proxy.Verbose = false
   filter := goproxy.ReqHostMatches(regexp.MustCompile(`xxx`))
   proxy.OnRequest(filter).HandleConnect(goproxy.AlwaysMitm)
   proxy.OnRequest(filter).DoFunc(func(req *http.Request, ctx *goproxy.ProxyCtx) (*http.Request, *http.Response) {
      if req.Method == "OPTIONS" {
         Log(LogLevelInfo, "OPTIONS (已忽略)")
         // 使用 204 No Content 作为标准响应状态码
         resp := goproxy.NewResponse(
            req,
            goproxy.ContentTypeText, // 自动设置为 "text/plain"
            http.StatusNoContent,    // 204
            "",
         )
         resp.Header.Set("Access-Control-Allow-Origin", "*")
         resp.Header.Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
         resp.Header.Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
         resp.Header.Set("Vary", "Origin, Access-Control-Request-Headers")
         return req, resp
      }

      path := req.URL.Path
      switch {
      case strings.HasPrefix(path, "activate"):
         b, _ := io.ReadAll(req.Body)
         g := gjson.ParseBytes(b)
         resp := goproxy.NewResponse(req, "application/json", http.StatusOK, makeFakeBody(g.Get("license_key").String(), "?"))
         resp.Header.Set("Access-Control-Allow-Origin", "*")
         resp.Header.Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
         resp.Header.Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
         resp.Header.Set("Vary", "Origin, Access-Control-Request-Headers")
         return req, resp
      }
      return req, nil
   })

   return proxy
}
```

写的略丑，能跑就行（
