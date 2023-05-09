set -x
curl -w "\n\n" -X GET  "http://0.0.0.0:8082/health"

curl -w "\n\n" -X GET  "http://0.0.0.0:8082/v1/origins_stats"
curl -w "\n\n" -X POST "http://0.0.0.0:8082/v1/origins_stats"

curl -w "\n\n" -X GET  "http://0.0.0.0:8082/v1/origins_stats?time_from=2020-04-06T23:27:54.000Z&time_to=2023-04-08T07:11:04.000Z"
curl -w "\n\n" -X POST "http://0.0.0.0:8082/v1/origins_stats" -F "time_from=2023-04-06T23:27:54.000Z" -F "time_to=2023-04-08T07:11:04.000Z"

curl -w "\n\n" -X GET  "http://0.0.0.0:8082/v1/origins_stats?time_from=2020-04-06T23:27:54.000Z"
curl -w "\n\n" -X POST "http://0.0.0.0:8082/v1/origins_stats" -F "time_from=2023-04-06T23:27:54.000Z"

curl -w "\n\n" -X GET  "http://0.0.0.0:8082/v1/origins_stats?time_to=2023-04-08T07:11:04.000Z"
curl -w "\n\n" -X POST "http://0.0.0.0:8082/v1/origins_stats" -F "time_to=2023-04-08T07:11:04.000Z"

curl -w "\n\n" -X GET  "http://0.0.0.0:8082/v1/origins_stats?time_from=2023-04-08T07:11:04.000Z&time_to=2020-04-06T23:27:54.000Z"
curl -w "\n\n" -X POST "http://0.0.0.0:8082/v1/origins_stats" -F "time_from=2023-04-08T07:11:04.000Z" -F "time_to=2023-04-06T23:27:54.000Z"
