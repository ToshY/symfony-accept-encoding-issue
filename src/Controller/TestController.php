<?php

namespace App\Controller;

use App\Service\MeilisearchPsrClient;
use Meilisearch\Client;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class TestController extends AbstractController
{
    public function __construct(
        #[Autowire(service: MeilisearchPsrClient::class)]
        private readonly Client $client,
    )
    {
    }


    #[Route('/test', name: 'app_test')]
    public function index(): Response
    {
        $result = $this->client->getIndexes();
        dump($result);

        return $this->render('test/index.html.twig', [
            'controller_name' => 'TestController',
        ]);
    }
}
