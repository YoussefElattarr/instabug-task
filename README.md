# Instabug Task

This project is an api for a chat system. The project uses the following:

  - Ruby on Rails
  - MySQL DB
  - Elasticsearch
  - Redis
  - Sidekiq

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Git
- Docker

### Clone the Repository

```bash
git clone https://github.com/YoussefElattarr/instabug-taskt.git
cd your-project
```

### Environment Variables

Create a .env file in the root of the project based on the provided .env.example. 

### Run the Application

```bash
docker-compose up
```

### API Endpoints

The API provides the following endpoints:

  - POST api/v1/applications Create a new application using the following body:
    ```json
    {"name":"name1"}
    ```
  - GET  api/v1/applications Retrieve details of all applications.
  - GET  api/v1/applications/:token Retrieve details of a specific application.
  - PUT  api/v1/applications/:token Update a specific application using the following body:
    ```json
    {"name":"updated name"}
    ``` 
  - DELETE api/v1/applications/:token Delete a specific application. 
  - POST api/v1/applications/:token/chats Create a new chat, no need to specify a body.
  - GET  api/v1/applications/:token/chats/ Retrieve details all chats within an application.
  - GET  api/v1/applications/:token/chats/:number Retrieve details of a specific chat within an application.
  - PUT  api/v1/applications/:token/chats/:number Update a specific chat within an application using the following body:
    ```json
    {"chat_number":3}
    ```
  - DELETE api/v1/applications/:token/chats/:number Delete a specific chat within an application.
  - POST api/v1/applications/:token/chats/:number/messages Create a new message within a chat using the following body:
    ```json
    {"body":"body"}
    ```
  - GET  api/v1/applications/:token/chats/:number/messages/ Retrieve details of all messages within a chat.
  - GET  api/v1/applications/:token/chats/:number/messages/:message_number Retrieve details of a specific message within a chat.
  - PUT  api/v1/applications/:token/chats/:number/messages/:message_number Update a specific message within a chat using the following body:
    ```json
    {
      "message_number":3
      "body":"updated body"
    }
    ```
  - DELETE  api/v1/applications/:token/chats/:number/messages/:message_number Delete a specific message within a chat.
  - GET api/v1/applications/:token/chats/:number/messages/search?q=:search_query Retrieve messages within a chat with body containing the search query

Make sure to replace :token, :number, :message_number, and :search_query with actual values.




