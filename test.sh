HOST="http://0.0.0.0:8082"

set -x
curl -w "\n\n" -X GET  "$HOST/health"

curl -w "\n\n" -X GET  "$HOST/v1/origins_stats"
curl -w "\n\n" -X POST "$HOST/v1/origins_stats"

curl -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-06T23:27:54.000Z&time_to=2023-04-08T07:11:04.000Z"
curl -w "\n\n" -X POST "$HOST/v1/origins_stats" -F "time_from=2023-04-06T23:27:54.000Z" -F "time_to=2023-04-08T07:11:04.000Z"

curl -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-06T23:27:54.000Z"
curl -w "\n\n" -X POST "$HOST/v1/origins_stats" -F "time_from=2023-04-06T23:27:54.000Z"

curl -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_to=2023-04-08T07:11:04.000Z"
curl -w "\n\n" -X POST "$HOST/v1/origins_stats" -F "time_to=2023-04-08T07:11:04.000Z"

curl -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-08T07:11:04.000Z&time_to=2023-04-06T23:27:54.000Z"
curl -w "\n\n" -X POST "$HOST/v1/origins_stats" -F "time_from=2023-04-08T07:11:04.000Z" -F "time_to=2023-04-06T23:27:54.000Z"

curl -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-06&time_to=2023-04-08"
curl -w "\n\n" -X POST "$HOST/v1/origins_stats" -F "time_from=2023-04-06" -F "time_to=2023-04-08"
