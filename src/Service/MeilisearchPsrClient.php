<?php

declare(strict_types=1);

namespace App\Service;

use Meilisearch\Client;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpClient\HttpClient;
use Symfony\Component\HttpClient\Psr18Client;
use Symfony\Component\HttpClient\Retry\GenericRetryStrategy;
use Symfony\Component\HttpClient\RetryableHttpClient;

final class MeilisearchPsrClient extends Client
{
    public function __construct(
        #[Autowire(env: 'MEILISEARCH_URL')]
        private readonly string $url,
        #[Autowire(env: 'MEILISEARCH_MASTER_KEY')]
        private readonly string $apiKey,
    ) {
        $client = new Psr18Client(
            new RetryableHttpClient(
                client: HttpClient::create(defaultOptions: [
                    'timeout' => 10,
                    'max_duration' => 20,
                ]),
                strategy: new GenericRetryStrategy(
                    delayMs: 3000,
                    multiplier: 5,
                    jitter: 0.25,
                ),
            ),
        );

        parent::__construct(
            $this->url,
            $this->apiKey,
            $client,
        );
    }
}