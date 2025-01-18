Reproduction for decompression issue using [Meilisearch](https://www.meilisearch.com/) (with [PHP wrapper](https://github.com/meilisearch/meilisearch-php)) and
[curl-impersonate](https://github.com/lexiforest/curl-impersonate).

Follow set-up below and visit [`localhost:8081/test`](http://localhost:8081/test) aftewards.

Stack-trace as follows.

```text
RuntimeException:
Unable to read stream contents: inflate_add(): data error

  at vendor/nyholm/psr7/src/Stream.php:266
  at Nyholm\Psr7\Stream::Nyholm\Psr7\{closure}(2, 'inflate_add(): data error', '/app/vendor/symfony/http-client/Response/TransportResponseTrait.php', 196)
  at inflate_add(object(InflateContext), '{"results":[],"offset":0,"limit":20,"total":0}')
     (vendor/symfony/http-client/Response/TransportResponseTrait.php:196)
  at Symfony\Component\HttpClient\Response\CurlResponse::stream(array(object(CurlResponse)), 0.0)
  at Generator->rewind()
     (vendor/symfony/http-client/Response/ResponseStream.php:47)
  at Symfony\Component\HttpClient\Response\ResponseStream->rewind()
     (vendor/symfony/http-client/Response/AsyncResponse.php:256)
  at Symfony\Component\HttpClient\Response\AsyncResponse::stream(array(object(AsyncResponse)), 0.0)
     (vendor/symfony/http-client/Response/StreamWrapper.php:123)
  at Symfony\Component\HttpClient\Response\StreamWrapper->stream_read(8192)
  at stream_get_contents(resource)
     (vendor/nyholm/psr7/src/Stream.php:270)
  at Nyholm\Psr7\Stream->getContents()
     (vendor/nyholm/psr7/src/StreamTrait.php:23)
  at Nyholm\Psr7\Stream->__toString()
     (vendor/meilisearch/meilisearch-php/src/Http/Client.php:189)
  at Meilisearch\Http\Client->parseResponse(object(Response))
     (vendor/meilisearch/meilisearch-php/src/Http/Client.php:157)
  at Meilisearch\Http\Client->execute(object(Request))
     (vendor/meilisearch/meilisearch-php/src/Http/Client.php:71)
  at Meilisearch\Http\Client->get('/indexes', array())
     (vendor/meilisearch/meilisearch-php/src/Endpoints/Indexes.php:99)
  at Meilisearch\Endpoints\Indexes->allRaw(array())
     (vendor/meilisearch/meilisearch-php/src/Endpoints/Indexes.php:86)
  at Meilisearch\Endpoints\Indexes->all(null)
     (vendor/meilisearch/meilisearch-php/src/Endpoints/Delegates/HandlesIndex.php:17)
  at Meilisearch\Client->getIndexes()
     (src/Controller/TestController.php:25)
  at App\Controller\TestController->index()
     (vendor/symfony/http-kernel/HttpKernel.php:181)
  at Symfony\Component\HttpKernel\HttpKernel->handleRaw(object(Request), 1)
     (vendor/symfony/http-kernel/HttpKernel.php:76)
  at Symfony\Component\HttpKernel\HttpKernel->handle(object(Request), 1, true)
     (vendor/symfony/http-kernel/Kernel.php:197)
  at Symfony\Component\HttpKernel\Kernel->handle(object(Request))
     (vendor/symfony/runtime/Runner/Symfony/HttpKernelRunner.php:35)
  at Symfony\Component\Runtime\Runner\Symfony\HttpKernelRunner->run()
     (vendor/autoload_runtime.php:29)
  at require_once('/app/vendor/autoload_runtime.php')
     (public/index.php:5) 
```
---

### 🧰 Prerequisites

* [Docker Compose (v2.21.0+)](https://docs.docker.com/compose/install/)
* [Task](https://taskfile.dev/installation/) (Optional; commands can be drived from [`.tasks/`](.tasks/) directory)
* [Reverse proxy | Traefik](https://doc.traefik.io/traefik/) (Optional)

> [!TIP]
> You can switch out Traefik for any other reverse proxy of your choice (or not use a reverse proxy at all), although
> this requires additional tweaking of labels (or exposing ports) in the docker compose configuration.

## 🎬 Get Started

### Update hosts file

Add `webapp.local` to your hosts files, e.g. `/etc/hosts` (Unix).

### Initialise dotenv

For first time setup, initialise the `.env.local` from the `.env`.

```shell
task init
```

You can now tweak the values in the `.env.local` if needed.

### Start application services

```shell
task up
```

### Visit the application

If the reverse proxy is configured correctly, you should be able to visit [`webapp.local`](http://webapp.local) or [`localhost:8081`](http://localhost:8081) in your browser and be
greeted by Symfony's default landing page.

> [!NOTE]
> You can disregard the SSL certificate warnings for development usages.
